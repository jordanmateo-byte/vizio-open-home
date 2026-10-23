import fs from 'node:fs';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
export const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
export const privateDir=process.env.VIZIO_OPEN_HOME_STATE?path.resolve(process.env.VIZIO_OPEN_HOME_STATE):path.join(root,'.private');
export function privatePath(name){fs.mkdirSync(privateDir,{recursive:true,mode:0o700});return path.join(privateDir,name);}
export function writePrivate(name,text){const p=privatePath(name);fs.writeFileSync(p,text,{mode:0o600});return p;}
export function lanAddress(value){if(!/^(?:\d{1,3}\.){3}\d{1,3}$/.test(value||''))throw Error('Usa una dirección IPv4 privada de tu LAN');const a=value.split('.').map(Number);if(a.some(n=>n>255)||!(a[0]===10||(a[0]===172&&a[1]>=16&&a[1]<=31)||(a[0]===192&&a[1]===168)))throw Error('Solo se admiten IP privadas RFC1918');return value;}
