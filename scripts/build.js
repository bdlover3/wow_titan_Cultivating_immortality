
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const addonName = 'WoWCultivation';
const sourceDir = path.join(__dirname, '..', addonName);

// ---- 根据 .env 环境变量切换 WoW 目录 ----
const WOW_DIRS = {
    home: 'D:\\Game\\World of Warcraft\\_classic_titan_\\Interface\\AddOns',
    backup: 'D:\\backup\\World of Warcraft\\_classic_titan_\\Interface\\AddOns',
};

let workplace = 'backup';
const envPath = path.join(__dirname, '..', '.env');
if (fs.existsSync(envPath)) {
    const envContent = fs.readFileSync(envPath, 'utf-8');
    const match = envContent.match(/workplace\s*=\s*"(\w+)"/);
    if (match) {
        workplace = match[1];
    }
}

const wowDir = WOW_DIRS[workplace] || WOW_DIRS.backup;
const targetDir = path.join(wowDir, addonName);

console.log('========================================');
console.log('魔兽修仙传 - 构建脚本');
console.log('========================================');
console.log(`当前工作环境: ${workplace} → ${wowDir}`);
console.log('');

function deleteDirectory(dir) {
    if (fs.existsSync(dir)) {
        try {
            if (process.platform === 'win32') {
                execSync(`rmdir /S /Q "${dir}"`, { stdio: 'ignore' });
            } else {
                execSync(`rm -rf "${dir}"`, { stdio: 'ignore' });
            }
            console.log(`已删除旧目录: ${dir}`);
            return true;
        } catch (err) {
            console.error(`删除失败: ${err.message}`);
            return false;
        }
    }
    return true;
}

function copyDirectory(src, dest) {
    try {
        if (process.platform === 'win32') {
            execSync(`xcopy /E /I /Y "${src}" "${dest}"`, { stdio: 'ignore' });
        } else {
            execSync(`cp -r "${src}" "${dest}"`, { stdio: 'ignore' });
        }
        return true;
    } catch (err) {
        console.error(`复制失败: ${err.message}`);
        return false;
    }
}

function ensureDirectory(dir) {
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
        console.log(`创建目录: ${dir}`);
    }
}

console.log(`源目录: ${sourceDir}`);
console.log(`目标目录: ${targetDir}\n`);

if (!fs.existsSync(sourceDir)) {
    console.error(`错误: 源目录不存在 - ${sourceDir}`);
    process.exit(1);
}

ensureDirectory(wowDir);

console.log('正在删除旧文件...');
const deleteSuccess = deleteDirectory(targetDir);
if (!deleteSuccess) {
    console.error('无法删除旧目录，构建中止');
    process.exit(1);
}

console.log('正在复制插件文件...');
const copySuccess = copyDirectory(sourceDir, targetDir);

if (copySuccess) {
    console.log('\n✅ 构建成功!');
    console.log(`插件已复制到: ${targetDir}`);
    
    const files = fs.readdirSync(targetDir);
    console.log(`\n复制的文件数量: ${files.length}`);
} else {
    console.error('\n❌ 构建失败!');
    process.exit(1);
}

console.log('\n========================================');
