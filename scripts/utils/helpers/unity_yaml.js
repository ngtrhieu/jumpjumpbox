const YAML = require("yaml");
const _ = require("lodash");

const parse = (yaml) => {
  const DOCUMENT_MARKER_REGEX = new RegExp(/^---\s(!\w!\d+)\s(\&\d+)$/);

  let lines = yaml.split("\n");

  const header = [];
  while (lines.length > 0 && !lines[0].match(DOCUMENT_MARKER_REGEX)) {
    header.push(lines.shift());
  }

  let documents = {};
  let currentDocument;
  while (lines.length > 0) {
    const line = lines.shift();
    if (line.match(DOCUMENT_MARKER_REGEX)) {
      currentDocument = line;
      documents[currentDocument] = [];
    } else if (currentDocument) {
      documents[currentDocument].push(line);
    }
  }

  documents = _.mapValues(documents, (doc) => YAML.parse(doc.join("\n")));

  return { header, documents };
};

const stringify = ({ header, documents }) => {
  const lines = [...header];

  _.each(documents, (doc, key) => {
    lines.push(key);

    let docYaml = YAML.stringify(doc);

    // Make sure docYaml is in UnityYAML-readable format
    // Substitute null property from `? <property>` to `- <property>:`
    const re = new RegExp(/(\w*)(\?)(.*)\n/);
    const replacement = "$1-$3:\n";
    while (docYaml.match(re)) {
      docYaml = docYaml.replace(re, replacement);
    }

    lines.push(docYaml);
  });

  return lines.join("\n");
};

module.exports = { parse, stringify };
