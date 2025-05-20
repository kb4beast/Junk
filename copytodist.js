const fs = require('fs-extra');
const path = require('path');

const APP_NAME = 'appName'; // Shorthand, not the full project name
const ROOT_DIR = path.resolve(__dirname, '..'); 
const CONFIG_FOLDER = path.join(ROOT_DIR, 'cf'); // Where .profile, Staticfile, nginx live
const DIST_DIR = path.join(ROOT_DIR, 'dist', APP_NAME, 'dist'); // Final target: dist/appName/dist

async function copyConfig() {
  try {
    console.log(`📦 Copying from '${CONFIG_FOLDER}' to '${DIST_DIR}'`);

    await fs.copy(CONFIG_FOLDER, DIST_DIR, { overwrite: true });

    const files = fs.readdirSync(DIST_DIR, { withFileTypes: true });
    files.forEach(file =>
      console.log(file.isFile() ? `📄 ${file.name}` : `📁 ${file.name}`)
    );

    console.log('✅ Config files copied!');
  } catch (err) {
    console.error('❌ Copy failed:', err);
    process.exit(1);
  }
}

copyConfig();
