if (typeof (count) != 'undefined') 
    count++
else {
    globalThis.count = 0;
    count++;
}


var definitionName = section;
var variableName = `_${definitionName.toUpperCase()}_${count}`;
var macro = `#!${(type == 'player' ? 'defineMember' : 'define')}`;

var code = `
${type}var ${variableName}
`;

for (let index in variables) {
    var localName = variables[index];

    if (localName.startsWith('#')) {
        localName = localName.substring(1);
        mappedVarName = `_${definitionName.toUpperCase()}_${++count}`;
        code += `${type}var ${mappedVarName}\n`;
        code += `${macro} ${definitionName}_${localName} ${mappedVarName}\n\n`;
    }
    else {
        code += `${macro} ${definitionName}_${localName} ${variableName}[${index}]\n\n`
    }
}

code