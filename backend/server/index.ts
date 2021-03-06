import express from "express";
import path from "path";
import { promises as fs } from "fs";
import { PKPass } from "passkit-generator";
import dotenv from "dotenv";

dotenv.config({ path: './.env' });

const app = express();

app.use(express.json());

const certificatesCache: Partial<{
  signerCert: Buffer;
  signerKey: Buffer;
  wwdr: Buffer;
  signerKeyPassphrase: string;
}> = {};

async function getCertificates(): Promise<typeof certificatesCache> {
  if (Object.keys(certificatesCache).length) {
    return certificatesCache;
  }

  const [signerCert, signerKey, wwdr, signerKeyPassphrase] =
    await Promise.all([
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
      Promise.resolve(process.env.SIGNER_KEY_PASSPHRASE),
    ]);

  Object.assign(certificatesCache, {
    signerCert,
    signerKey,
    wwdr,
    signerKeyPassphrase,
  });

  return certificatesCache;
}

// 0.0.0.0:8000/<barcodeValue>
app.route("/:barcodeValue").get(async (request, response) => {
  const passName = "khupass" + "-" + request.params.barcodeValue;
  const studentID = request.params.barcodeValue.substring(0, 10);

  const [iconFromModel, logoFromModel, stripFromModel, certificates] =
    await Promise.all([
      fs.readFile(
        path.resolve(__dirname, "./static/icon.png"),
      ),
      fs.readFile(
        path.resolve(__dirname, "./static/logo.png"),
      ),
      fs.readFile(
        path.resolve(__dirname, "./static/strip.png"),
      ),
      await getCertificates(),
    ]);

  try {
    const pass = new PKPass(
      {},
      {
        wwdr: certificates.wwdr,
        signerCert: certificates.signerCert,
        signerKey: certificates.signerKey,
        signerKeyPassphrase: certificates.signerKeyPassphrase,
      },
      {
        ...(request.body || request.params || request.query),
        description: "KHU PASS",
        passTypeIdentifier: process.env.PASS_TYPE_IDENTIFIER,
        serialNumber: request.params.barcodeValue,
        organizationName: "KHU PASS",
        teamIdentifier: process.env.TEAM_IDENTIFIER,
        associatedStoreIdentifiers: [1598848741],
        logoText: "KHU PASS",
        foregroundColor: "rgb(255, 255, 255)",
        labelColor: "rgb(13, 50, 111)",
        backgroundColor: "rgb(164, 15, 22)",
      },
    );

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
      message: request.params.barcodeValue,
      format: "PKBarcodeFormatQR",
    });

    pass.secondaryFields.push(
      {
        key: "studentID",
        label: "??????",
        value: studentID,
        textAlignment: "PKTextAlignmentLeft",
      }
    );

    pass.backFields.push(
      {
        key: "back-github",label: "?????????",
        value: "????????? <a href='https://github.com/Chuncheonian'>@Chuncheonian</a>"
      },
      {
        key: "back-email",
        label: "????????????",
        value: "<a href='mailto:chuncheon@duck.com'>chuncheon@duck.com</a>"
      },
      {
        key: "back-role",
        label: "????????????",
        value: "??? ????????? ??????????????? ??????????????? ????????? ?????? ????????????. ?????? ?????? ??? ??????????????? ????????? ??? ?????????, ????????? ???????????? ?????? ????????????.",
      },
      {
        key: "back-studentID",
        label: "??????",
        value: studentID,
      }
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

    const stream = pass.getAsStream();

    response.set({
      "Content-type": pass.mimeType,
      "Content-disposition": `attachment; filename=${passName}.pkpass`,
    });

    stream.pipe(response);
  } catch (err) {
    console.log(err);

    response.set({
      "Content-type": "text/html",
    });

    response.send(err.message);
  }
});

app.listen(8080, "0.0.0.0", () => {
  console.log("Webserver started.");
});
