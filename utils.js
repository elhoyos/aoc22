const fs = require('fs');
const readline = require('node:readline');

async function readLineInterfaceOfFile(filepath) {
  const fileStream = fs.createReadStream(filepath);
  return readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity,
  });
}

module.exports = {readLineInterfaceOfFile};
