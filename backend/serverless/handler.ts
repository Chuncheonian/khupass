import AWS from "aws-sdk";
import { ALBEvent, ALBResult } from "aws-lambda";
import { promises as fs } from "fs";
import path from "path";
import { PKPass } from "passkit-generator";
import config from "./config.json";

const S3: { instance: AWS.S3 } = { instance: undefined };

export async function generatePass(event: ALBEvent) {
  const studentID = event.queryStringParameters.barcodeValue.substring(0, 10);

  const passGenerator = createPassGenerator(
    event.queryStringParameters.barcodeValue,
    {
      description: "KHU PASS",
      passTypeIdentifier: config.PASS_TYPE_IDENTIFIER,
      serialNumber: event.queryStringParameters.barcodeValue,
      organizationName: "KHU PASS",
      teamIdentifier: config.TEAM_IDENTIFIER,
      associatedStoreIdentifiers: [1598848741],
      logoText: "KHU PASS",
      foregroundColor: "rgb(255, 255, 255)",
      labelColor: "rgb(13, 50, 111)",
      backgroundColor: "rgb(164, 15, 22)",
    },
  );

  const [{ value }, iconFromModel, logoFromModel, stripFromModel] =
    await Promise.all([
      passGenerator.next(),
      fs.readFile(path.resolve(__dirname, "./static/icon.png")),
      fs.readFile(path.resolve(__dirname, "./static/logo.png")),
      fs.readFile(path.resolve(__dirname, "./static/strip.png"))
    ]);

  const pass = value as PKPass;

  pass.type = "storeCard";

  pass.setLocations(
    {
      longitude: 127.079886,
      latitude: 37.240863,
    },
    {
      longitude: 127.05278413141518,
      latitude: 37.5965767488143,
    },
  );

  pass.setBarcodes({
    message: event.queryStringParameters.barcodeValue,
    format: "PKBarcodeFormatQR",
  });

  pass.secondaryFields.push({
    key: "studentID",
    label: "학번",
    value: studentID,
    textAlignment: "PKTextAlignmentLeft",
  });

  pass.backFields.push(
    {
      key: "back-github",
      label: "개발자",
      value: "권동영 <a href='https://github.com/Chuncheonian'>@Chuncheonian</a>",
    },
    {
      key: "back-email",
      label: "문의사항",
      value: "<a href='mailto:chuncheon@duck.com'>chuncheon@duck.com</a>",
    },
    {
      key: "back-role",
      label: "유의사항",
      value: "이 패스는 경희대학교 공식적으로 발급된 것이 아닙니다. 실제 사용 시 정상적으로 인식이 안 되거나, 사용을 거부당할 수도 있습니다.",
    },
    {
      key: "back-studentID",
      label: "학번",
      value: studentID,
    },
  );

  pass.addBuffer("icon.png", iconFromModel);
  pass.addBuffer("icon@2x.png", iconFromModel);
  pass.addBuffer("icon@3x.png", iconFromModel);

  pass.addBuffer("logo.png", logoFromModel);
  pass.addBuffer("logo@2x.png", logoFromModel);
  pass.addBuffer("logo@3x.png", logoFromModel);

  pass.addBuffer("strip.png", stripFromModel);
  pass.addBuffer("strip@2x.png", stripFromModel);
  pass.addBuffer("strip@3x.png", stripFromModel);

  return (await passGenerator.next(pass as PKPass)).value as ALBResult;
}

async function* createPassGenerator(
  barcodeValue?: string,
  passOptions?: Object,
): AsyncGenerator<PKPass, ALBResult, PKPass> {
  const [certificates, s3] = await Promise.all([
    getCertificates(),
    getS3Instance(),
  ]);

  let pass = new PKPass(
    {},
    {
      wwdr: certificates.wwdr,
      signerCert: certificates.signerCert,
      signerKey: certificates.signerKey,
      signerKeyPassphrase: certificates.signerKeyPassphrase,
    },
    passOptions,
  );
  pass = yield pass;

  const buffer = pass.getAsBuffer();
  const passName = "khupass" + "-" + `${barcodeValue}`;

  const { Location } = await s3
    .upload({
      Bucket: config.AWS_S3_TEMP_BUCKET,
      Key: passName,
      ContentType: pass.mimeType,
      /** Marking it as expiring in 5 minutes, because passes should not be stored */
      Expires: new Date(Date.now() + 5 * 60 * 1000),
      ContentDisposition: `attachment; filename="${passName}.pkpass"`,
      Body: buffer,
    })
    .promise();

  return {
    statusCode: 302,
    headers: {
      "Content-Type": "application/vnd.apple.pkpass",
      Location: Location,
    },
  };
}

async function getCertificates(): Promise<{
  signerCert: string | Buffer;
  signerKey: string | Buffer;
  wwdr: string | Buffer;
  signerKeyPassphrase?: string;
}> {
  let signerCert: string;
  let signerKey: string;
  let wwdr: string;
  let signerKeyPassphrase: string;

  [signerCert, signerKey, wwdr, signerKeyPassphrase] = await Promise.all([
    fs.readFile(
      path.resolve(__dirname, "./certificates/signerCert.pem"),
      "utf-8",
    ),
    fs.readFile(
      path.resolve(__dirname, "./certificates/signerKey.pem"),
      "utf-8",
    ),
    fs.readFile(
      path.resolve(__dirname, "./certificates/WWDR.pem"),
      "utf-8",
    ),
    Promise.resolve(config.SIGNER_KEY_PASSPHRASE),
  ]);

  return {
    signerCert,
    signerKey,
    wwdr,
    signerKeyPassphrase,
  };
}

async function getS3Instance() {
  if (S3.instance) {
    console.log("S3 instance already exists");
    return S3.instance;
  }
  console.log("Creating S3 instance");

  const instance = new AWS.S3({
    s3ForcePathStyle: true,
    accessKeyId: config.AWS_ACCESS_KEY_ID,
    secretAccessKey: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION,
    endpoint: new AWS.Endpoint(config.AWS_S3_ENDPOINT),
  });

  S3.instance = instance;

  try {
    /** Trying to create a new bucket. If it fails, it already exists (at least in theory) */
    await instance
      .createBucket({ Bucket: config.AWS_S3_TEMP_BUCKET })
      .promise();
  } catch (err) {}

  return instance;
}