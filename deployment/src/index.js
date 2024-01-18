const functions = require('@google-cloud/functions-framework');

functions.http('main', async (req, res) => {
  try {
    const response = await fetch('http://34.122.43.155/');

    if (!response.ok) {
      throw new Error(`HTTP request failed with status ${response.status}`);
    }

    const data = await response.text();
    res.send(`Response: ${data}`);
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});
