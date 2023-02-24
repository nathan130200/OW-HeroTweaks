if(typeof numConfigs == 'undefined') {
    globalThis.numConfigs = 1;
}
else {
    numConfigs++;
}

var configVar = `_CONFIGS_${numConfigs}`;
var macros = [], actions = [];

for (let index in props) {
    var { key, name, type, value } = props[index];
    macros.push(`#!define ${key} ${configVar}[${index}]\n`);
    actions.push(`_CONFIGS_${numConfigs}[${index}] = createWorkshopSetting(${type}, "${category}", "${name}", ${value}, ${index})`);
}

`
globalvar ${configVar}

${macros.join('\n')}

rule "config '${category}': init":
    @Event global
    ${actions.join('\n\t')}`