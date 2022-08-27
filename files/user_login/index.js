exports.handler = async (event) => {
  try {
    var body = event.Records[0].body;
    const result = await getRequest(body, url);

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
    };
  } catch (error) {
    console.log('Error is: ', error);
    return {
      statusCode: 400,
      body: error.message,
    };
  }

};

function getRequest(pBody, pUrl) {
  url = pUrl + "?" + pBody;

  return new Promise((resolve, reject) => {
    const req = https.get(url, res => {
      let rawData = '';

      res.on('data', chunk => {
        rawData += chunk;
      });

      res.on('end', () => {
        try {
          //nothing to do
        } catch (err) {
          reject(new Error(err));
        }
      });
    });

    req.on('error', err => {
      reject(new Error(err));
    });
  });
}