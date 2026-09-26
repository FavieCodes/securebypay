import fs from 'fs';
import path from 'path';
import swaggerSpec from '../src/docs/swagger';

const outPath = path.join(__dirname, '../src/docs/openapi.generated.json');
fs.writeFileSync(outPath, JSON.stringify(swaggerSpec, null, 2));
console.log(`Wrote OpenAPI spec to ${outPath}`);