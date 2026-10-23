import fs from 'node:fs';import path from 'node:path';import {root} from './common.mjs';
const catalog=JSON.parse(fs.readFileSync(path.join(root,'data/catalog.json'),'utf8'));
const runtime=fs.readFileSync(path.join(root,'src/runtime.js'),'utf8').replace('__CATALOG_JSON__',JSON.stringify(catalog).replaceAll('<','\\u003c'));
new Function(runtime);
const html=fs.readFileSync(path.join(root,'src/index.template.html'),'utf8').replace('__RUNTIME_JS__',runtime);
if(html.includes('__RUNTIME_JS__')||html.includes('__CATALOG_JSON__'))throw Error('Quedaron marcadores sin sustituir');
fs.mkdirSync(path.join(root,'dist'),{recursive:true});fs.writeFileSync(path.join(root,'dist/index.html'),html.replace(/^\uFEFF/,'').replaceAll('\r\n','\n'));
console.log(`Build: ${Buffer.byteLength(html)} bytes, ${catalog.length} entradas del catálogo`);
