#!/bin/bash

# 增强版文件创建工具 - 交互式使用手册
# Enhanced File Creator - Interactive Manual

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 手册信息
MANUAL_VERSION="2.0"
SCRIPT_NAME="enhanced_file_creator.sh"
MANUAL_SCRIPT="enhanced_manual.sh"

# 临时HTML文件路径
HTML_MANUAL="/tmp/enhanced_file_creator_manual.html"

# 函数：显示标题
show_header() {
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║             增强版文件/文件夹创建工具 - 使用手册              ║"
    echo "║           Enhanced File Creator - User Manual v$MANUAL_VERSION         ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# 函数：检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 函数：生成HTML手册
generate_html_manual() {
    cat > "$HTML_MANUAL" << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>增强版文件创建工具 - 使用手册</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            text-align: center;
            margin-bottom: 30px;
        }
        .header h1 {
            color: #4a5568;
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        .header .version {
            color: #718096;
            font-size: 1.2em;
        }
        .nav {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        .nav-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .nav-item {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            text-decoration: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }
        .nav-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }
        .content {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .section {
            margin-bottom: 30px;
            padding: 20px;
            border-left: 5px solid #667eea;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .section h2 {
            color: #4a5568;
            margin-bottom: 15px;
            font-size: 1.8em;
        }
        .section h3 {
            color: #667eea;
            margin: 15px 0 10px 0;
        }
        .code-block {
            background: #2d3748;
            color: #e2e8f0;
            padding: 15px;
            border-radius: 8px;
            margin: 10px 0;
            overflow-x: auto;
            font-family: 'Courier New', monospace;
        }
        .tip {
            background: #e6fffa;
            border-left: 4px solid #38b2ac;
            padding: 15px;
            margin: 15px 0;
            border-radius: 4px;
        }
        .warning {
            background: #fed7d7;
            border-left: 4px solid #e53e3e;
            padding: 15px;
            margin: 15px 0;
            border-radius: 4px;
        }
        .feature-list {
            list-style: none;
            padding: 0;
        }
        .feature-list li {
            padding: 8px 0;
            border-bottom: 1px solid #e2e8f0;
        }
        .feature-list li:before {
            content: "✓ ";
            color: #48bb78;
            font-weight: bold;
        }
        .footer {
            text-align: center;
            color: white;
            padding: 20px;
            font-size: 0.9em;
        }
        .back-to-top {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: #667eea;
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-size: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
        }
        .back-to-top:hover {
            background: #764ba2;
            transform: translateY(-3px);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>增强版文件/文件夹创建工具</h1>
            <div class="version">使用手册 v2.0</div>
        </div>

        <div class="nav">
            <div class="nav-grid">
                <div class="nav-item" onclick="showSection('intro')">工具简介</div>
                <div class="nav-item" onclick="showSection('interactive')">交互模式</div>
                <div class="nav-item" onclick="showSection('api')">API模式</div>
                <div class="nav-item" onclick="showSection('templates')">文件名模板</div>
                <div class="nav-item" onclick="showSection('permissions')">权限管理</div>
                <div class="nav-item" onclick="showSection('remote')">远程操作</div>
                <div class="nav-item" onclick="showSection('examples')">使用示例</div>
                <div class="nav-item" onclick="showSection('troubleshoot')">故障排除</div>
            </div>
        </div>

        <div class="content">
            <!-- 简介部分 -->
            <div id="intro" class="section">
                <h2>📖 工具简介</h2>
                <p>增强版文件/文件夹批量创建工具是一个功能强大的Shell脚本，提供了直观的交互界面和灵活的API接口，满足各种文件管理需求。</p>
                
                <h3>✨ 主要特性</h3>
                <ul class="feature-list">
                    <li>友好的交互式界面 - 彩色显示，分步指导</li>
                    <li>灵活的API模式 - 支持命令行参数调用</li>
                    <li>无限数量创建 - 无文件数量限制</li>
                    <li>智能文件名模板 - 支持时间、序号等变量</li>
                    <li>完整的权限管理 - 支持自定义文件权限</li>
                    <li>远程文件操作 - 支持HTTP/HTTPS/FTP协议</li>
                    <li>自动脚本复制 - 智能复制脚本到目标位置</li>
                    <li>详细的错误处理 - 完善的错误提示和恢复</li>
                </ul>

                <div class="tip">
                    💡 工具支持本地和远程文件操作，既可以单独使用，也可以集成到其他脚本中。
                </div>
            </div>

            <!-- 交互模式部分 -->
            <div id="interactive" class="section" style="display:none;">
                <h2>🎯 交互模式使用指南</h2>
                
                <h3>启动交互模式</h3>
                <div class="code-block">
                    ./enhanced_file_creator.sh
                </div>

                <h3>使用步骤</h3>
                <ol>
                    <li><strong>选择创建类型</strong> - 文件、文件夹或远程文件</li>
                    <li><strong>指定目标位置</strong> - 本地路径或远程URL</li>
                    <li><strong>设置创建数量</strong> - 支持无限模式(输入0)</li>
                    <li><strong>配置文件名</strong> - 使用模板变量增强命名</li>
                    <li><strong>确认并创建</strong> - 预览后执行创建操作</li>
                </ol>

                <h3>交互模式特色</h3>
                <ul class="feature-list">
                    <li>彩色可视化界面，提升用户体验</li>
                    <li>实时路径验证和自动目录创建</li>
                    <li>创建前预览功能，避免误操作</li>
                    <li>详细的成功/失败报告</li>
                    <li>智能的默认值和提示信息</li>
                </ul>

                <div class="code-block">
                    # 示例：交互式创建日志文件<br>
                    $ ./enhanced_file_creator.sh<br>
                    → 选择: 文件<br>
                    → 目标: ./logs<br>
                    → 数量: 10<br>
                    → 名称: log_{DATE}_{INDEX}<br>
                    → 后缀: .log<br>
                    → 权限: 644
                </div>
            </div>

            <!-- API模式部分 -->
            <div id="api" class="section" style="display:none;">
                <h2>🔧 API模式使用指南</h2>
                
                <h3>基本语法</h3>
                <div class="code-block">
                    ./enhanced_file_creator.sh [选项]
                </div>

                <h3>可用参数</h3>
                <div class="code-block">
                    --type TYPE          创建类型: file 或 folder<br>
                    --target DIR         目标文件夹路径<br>
                    --quantity NUM       创建数量 (0=无限)<br>
                    --name NAME          基础文件名 (支持模板变量)<br>
                    --extension EXT      文件后缀名 (仅文件类型)<br>
                    --mode MODE          文件权限 (八进制, 如 755)<br>
                    --remote-url URL     远程URL (http/https/ftp/ftps)<br>
                    --remote-user USER   远程用户名<br>
                    --remote-pass PASS   远程密码<br>
                    --no-copy-script     不复制脚本到目标位置<br>
                    --non-interactive    非交互模式<br>
                    --help               显示帮助信息
                </div>

                <h3>API模式示例</h3>
                <div class="code-block">
                    # 创建5个文本文件<br>
                    ./enhanced_file_creator.sh --type file --target ./docs \<br>
                      --quantity 5 --name document --extension .txt --mode 644<br><br>

                    # 创建3个文件夹<br>
                    ./enhanced_file_creator.sh --type folder --target ./projects \<br>
                      --quantity 3 --name project --mode 755<br><br>

                    # 无限创建日志文件<br>
                    ./enhanced_file_creator.sh --type file --target ./logs \<br>
                      --quantity 0 --name "log_{DATETIME}" --extension .log<br><br>

                    # 远程创建文件<br>
                    ./enhanced_file_creator.sh --type remote \<br>
                      --remote-url ftp://example.com/uploads \<br>
                      --remote-user myuser --remote-pass mypass \<br>
                      --name remote_file --extension .txt
                </div>

                <div class="tip">
                    💡 API模式非常适合集成到自动化脚本、CI/CD流程或其他工具链中。
                </div>
            </div>

            <!-- 文件名模板部分 -->
            <div id="templates" class="section" style="display:none;">
                <h2>📝 文件名模板系统</h2>
                
                <h3>可用模板变量</h3>
                <div class="code-block">
                    {DATE}      当前日期 (YYYY-MM-DD)<br>
                    {TIME}      当前时间 (HH-MM-SS)<br>
                    {DATETIME}  当前日期时间 (YYYY-MM-DD_HH-MM-SS)<br>
                    {TIMESTAMP} 时间戳 (秒)<br>
                    {RANDOM}    随机数 (0-9999)<br>
                    {INDEX}     递增序号
                </div>

                <h3>模板使用示例</h3>
                <div class="code-block">
                    # 带日期和序号的备份文件<br>
                    --name "backup_{DATE}_{INDEX}"<br><br>

                    # 带时间戳的临时文件<br>
                    --name "temp_{TIMESTAMP}_{RANDOM}"<br><br>

                    # 详细的日志文件名<br>
                    --name "application_log_{DATETIME}"<br><br>

                    # 项目版本文件<br>
                    --name "v1_0_{DATE}_build_{INDEX}"
                </div>

                <h3>实际生成效果</h3>
                <div class="code-block">
                    模板: "backup_{DATE}_{INDEX}.tar.gz"<br>
                    生成: backup_2024-01-15_1.tar.gz<br>
                    生成: backup_2024-01-15_2.tar.gz<br>
                    生成: backup_2024-01-15_3.tar.gz
                </div>

                <div class="tip">
                    💡 模板变量可以任意组合使用，创建出具有意义的文件名结构。
                </div>
            </div>

            <!-- 权限管理部分 -->
            <div id="permissions" class="section" style="display:none;">
                <h2>🔐 权限管理功能</h2>
                
                <h3>权限表示法</h3>
                <p>工具使用标准的八进制权限表示法：</p>
                <div class="code-block">
                    755 = rwxr-xr-x (所有者:读/写/执行, 组:读/执行, 其他:读/执行)<br>
                    644 = rw-r--r-- (所有者:读/写, 组:读, 其他:读)<br>
                    777 = rwxrwxrwx (所有用户:读/写/执行)<br>
                    600 = rw------- (仅所有者:读/写)
                </div>

                <h3>常用权限场景</h3>
                <div class="code-block">
                    # 可执行脚本<br>
                    --mode 755<br><br>

                    # 配置文件<br>
                    --mode 644<br><br>

                    # 私有文件<br>
                    --mode 600<br><br>

                    # 共享目录<br>
                    --mode 777
                </div>

                <h3>权限设置示例</h3>
                <div class="code-block">
                    # 创建可执行脚本文件<br>
                    ./enhanced_file_creator.sh --type file --target ./scripts \<br>
                      --quantity 3 --name "script_{INDEX}" --extension .sh --mode 755<br><br>

                    # 创建私有数据文件夹<br>
                    ./enhanced_file_creator.sh --type folder --target ./data \<br>
                      --quantity 5 --name "private_{INDEX}" --mode 700
                </div>

                <div class="warning">
                    ⚠ 注意：设置过于宽松的权限(如777)可能存在安全风险，请谨慎使用。
                </div>
            </div>

            <!-- 远程操作部分 -->
            <div id="remote" class="section" style="display:none;">
                <h2>🌐 远程文件操作</h2>
                
                <h3>支持的协议</h3>
                <ul class="feature-list">
                    <li>HTTP - 超文本传输协议</li>
                    <li>HTTPS - 安全超文本传输协议</li>
                    <li>FTP - 文件传输协议</li>
                    <li>FTPS - 安全文件传输协议</li>
                </ul>

                <h3>认证方式</h3>
                <div class="code-block">
                    # 匿名访问 (无认证)<br>
                    --remote-url ftp://example.com/files<br><br>

                    # 用户名密码认证<br>
                    --remote-url ftp://example.com/uploads \<br>
                    --remote-user myusername --remote-pass mypassword<br><br>

                    # URL中包含认证信息<br>
                    --remote-url ftp://username:password@example.com/files
                </div>

                <h3>远程操作示例</h3>
                <div class="code-block">
                    # 上传文件到FTP服务器<br>
                    ./enhanced_file_creator.sh --type remote \<br>
                      --remote-url ftp://files.example.com/uploads \<br>
                      --remote-user uploader --remote-pass secret123 \<br>
                      --quantity 5 --name "upload_{DATE}_{INDEX}" --extension .txt<br><br>

                    # 通过HTTP创建文件 (需要服务器支持PUT)<br>
                    ./enhanced_file_creator.sh --type remote \<br>
                      --remote-url https://api.example.com/v1/files \<br>
                      --quantity 3 --name "api_file_{INDEX}" --extension .json
                </div>

                <div class="warning">
                    ⚠ 注意：远程操作功能需要目标服务器支持相应的协议和方法，并且需要网络连接。
                </div>
            </div>

            <!-- 使用示例部分 -->
            <div id="examples" class="section" style="display:none;">
                <h2>🚀 实际使用示例</h2>
                
                <h3>场景1：项目初始化</h3>
                <div class="code-block">
                    # 创建项目目录结构<br>
                    ./enhanced_file_creator.sh --type folder --target ./myproject \<br>
                      --quantity 1 --name "src" --mode 755<br>
                    ./enhanced_file_creator.sh --type folder --target ./myproject \<br>
                      --quantity 1 --name "docs" --mode 755<br>
                    ./enhanced_file_creator.sh --type folder --target ./myproject \<br>
                      --quantity 1 --name "tests" --mode 755<br><br>

                    # 创建基础配置文件<br>
                    ./enhanced_file_creator.sh --type file --target ./myproject \<br>
                      --quantity 1 --name "README" --extension .md --mode 644<br>
                    ./enhanced_file_creator.sh --type file --target ./myproject \<br>
                      --quantity 1 --name "package" --extension .json --mode 644
                </div>

                <h3>场景2：日志轮转</h3>
                <div class="code-block">
                    # 创建带时间戳的日志文件<br>
                    ./enhanced_file_creator.sh --type file --target /var/log/myapp \<br>
                      --quantity 10 --name "app_{DATETIME}" --extension .log --mode 644
                </div>

                <h3>场景3：备份系统</h3>
                <div class="code-block">
                    # 创建备份目录和标记文件<br>
                    ./enhanced_file_creator.sh --type folder --target /backups \<br>
                      --quantity 1 --name "backup_{DATE}" --mode 755<br>
                    ./enhanced_file_creator.sh --type file --target /backups/backup_{DATE} \<br>
                      --quantity 1 --name "backup_info" --extension .txt --mode 644
                </div>

                <h3>场景4：自动化部署</h3>
                <div class="code-block">
                    # 在CI/CD流程中创建版本文件<br>
                    ./enhanced_file_creator.sh --non-interactive --type file \<br>
                      --target ./dist --quantity 1 \<br>
                      --name "build_{TIMESTAMP}" --extension .version --mode 644
                </div>
            </div>

            <!-- 故障排除部分 -->
            <div id="troubleshoot" class="section" style="display:none;">
                <h2>🔧 故障排除</h2>
                
                <h3>常见问题及解决方案</h3>

                <h4>1. 权限错误</h4>
                <div class="code-block">
                    错误: 无法创建文件夹，请检查权限！<br>
                    解决: 使用sudo或以有权限的用户运行，或选择其他目录
                </div>

                <h4>2. 磁盘空间不足</h4>
                <div class="code-block">
                    错误: 设备上没有空间<br>
                    解决: 清理磁盘空间或选择其他存储位置
                </div>

                <h4>3. 远程连接失败</h4>
                <div class="code-block">
                    错误: 无法连接到远程服务器<br>
                    解决: 检查网络连接、URL格式和认证信息
                </div>

                <h4>4. 模板变量不生效</h4>
                <div class="code-block">
                    问题: 文件名显示为字面值 {DATE} {TIME}<br>
                    解决: 确保使用花括号 {} 包围变量名，且拼写正确
                </div>

                <h4>5. 脚本执行权限</h4>
                <div class="code-block">
                    错误: Permission denied<br>
                    解决: chmod +x enhanced_file_creator.sh
                </div>

                <h3>调试技巧</h3>
                <div class="code-block">
                    # 显示详细执行信息<br>
                    bash -x enhanced_file_creator.sh --type file --target ./test<br><br>

                    # 检查依赖命令<br>
                    which curl mkdir touch ls<br><br>

                    # 验证文件权限<br>
                    ls -la ./target_directory
                </div>

                <div class="tip">
                    💡 如果遇到问题，可以先在测试目录中用小规模数据验证功能。
                </div>
            </div>
        </div>

        <div class="footer">
            <p>增强版文件创建工具 v2.0 - 使用手册</p>
            <p>© 2024 版权所有 - 设计用于教育和生产环境</p>
        </div>
    </div>

    <a href="#" class="back-to-top">↑</a>

    <script>
        // 显示指定部分，隐藏其他部分
        function showSection(sectionId) {
            // 隐藏所有部分
            const sections = document.querySelectorAll('.section');
            sections.forEach(section => {
                section.style.display = 'none';
            });
            
            // 显示选中的部分
            document.getElementById(sectionId).style.display = 'block';
            
            // 滚动到顶部
            window.scrollTo(0, 0);
        }

        // 默认显示简介部分
        document.addEventListener('DOMContentLoaded', function() {
            showSection('intro');
        });

        // 返回顶部功能
        document.querySelector('.back-to-top').addEventListener('click', function(e) {
            e.preventDefault();
            window.scrollTo(0, 0);
        });
    </script>
</body>
</html>
EOF
}

# 函数：在浏览器中打开手册
open_browser_manual() {
    echo -e "${BLUE}正在生成HTML手册...${NC}"
    generate_html_manual
    
    echo -e "${GREEN}手册已生成: $HTML_MANUAL${NC}"
    echo -e "${YELLOW}正在尝试在浏览器中打开手册...${NC}"
    
    # 尝试不同的浏览器命令
    if command_exists xdg-open; then
        xdg-open "$HTML_MANUAL" 2>/dev/null &
        echo -e "${GREEN}已使用 xdg-open 打开手册${NC}"
    elif command_exists open; then
        open "$HTML_MANUAL" 2>/dev/null &
        echo -e "${GREEN}已使用 open 打开手册${NC}"
    elif command_exists firefox; then
        firefox "$HTML_MANUAL" 2>/dev/null &
        echo -e "${GREEN}已使用 Firefox 打开手册${NC}"
    elif command_exists google-chrome; then
        google-chrome "$HTML_MANUAL" 2>/dev/null &
        echo -e "${GREEN}已使用 Google Chrome 打开手册${NC}"
    elif command_exists chromium-browser; then
        chromium-browser "$HTML_MANUAL" 2>/dev/null &
        echo -e "${GREEN}已使用 Chromium 打开手册${NC}"
    else
        echo -e "${RED}未找到可用的浏览器程序${NC}"
        echo -e "${YELLOW}请手动在浏览器中打开: $HTML_MANUAL${NC}"
        return 1
    fi
    
    echo -e "${GREEN}手册已在浏览器中打开！${NC}"
    echo -e "${CYAN}手册文件位置: $HTML_MANUAL${NC}"
    return 0
}

# 函数：显示命令行手册
show_cli_manual() {
    show_header
    echo -e "${YELLOW}命令行快速参考${NC}"
    echo ""
    
    echo -e "${GREEN}基本用法:${NC}"
    echo -e "  ${CYAN}交互模式:${NC} ./$SCRIPT_NAME"
    echo -e "  ${CYAN}API模式:${NC} ./$SCRIPT_NAME [选项]"
    echo ""
    
    echo -e "${GREEN}常用选项:${NC}"
    echo -e "  ${BLUE}--type${NC} file|folder|remote   创建类型"
    echo -e "  ${BLUE}--target${NC} DIR               目标路径"
    echo -e "  ${BLUE}--quantity${NC} NUM             创建数量 (0=无限)"
    echo -e "  ${BLUE}--name${NC} NAME                文件名 (支持模板)"
    echo -e "  ${BLUE}--extension${NC} EXT            文件后缀"
    echo -e "  ${BLUE}--mode${NC} MODE                文件权限"
    echo -e "  ${BLUE}--help${NC}                     显示帮助"
    echo ""
    
    echo -e "${GREEN}模板变量:${NC}"
    echo -e "  {DATE} {TIME} {DATETIME} {TIMESTAMP} {RANDOM} {INDEX}"
    echo ""
    
    echo -e "${GREEN}示例:${NC}"
    echo -e "  ${YELLOW}创建文件:${NC} ./$SCRIPT_NAME --type file --target ./docs --quantity 5 --name doc --extension .txt"
    echo -e "  ${YELLOW}创建文件夹:${NC} ./$SCRIPT_NAME --type folder --target ./projects --quantity 3 --name project"
    echo -e "  ${YELLOW}远程操作:${NC} ./$SCRIPT_NAME --type remote --remote-url ftp://example.com --name remote_file"
    echo ""
    
    echo -e "${BLUE}更多详细信息请在浏览器中查看完整手册${NC}"
    echo ""
}

# 函数：显示主菜单
show_main_menu() {
    show_header
    echo -e "${YELLOW}请选择手册查看方式:${NC}"
    echo ""
    echo -e "${GREEN}1. 在浏览器中查看完整手册 (推荐)${NC}"
    echo -e "${GREEN}2. 命令行快速参考${NC}"
    echo -e "${GREEN}3. 显示工具使用方法${NC}"
    echo -e "${GREEN}4. 验证系统依赖${NC}"
    echo -e "${BLUE}5. 打开脚本所在目录${NC}"
    echo -e "${RED}0. 退出手册${NC}"
    echo ""
    read -p "请输入选择 (0-5): " choice
    
    case $choice in
        1)
            echo -e "${CYAN}启动浏览器手册...${NC}"
            if open_browser_manual; then
                echo ""
                echo -e "${GREEN}✅ 手册已成功在浏览器中打开${NC}"
                echo -e "${YELLOW}浏览器窗口可能隐藏在后台，请检查您的任务栏或窗口列表${NC}"
            else
                echo -e "${RED}❌ 无法自动打开浏览器${NC}"
                echo -e "${YELLOW}请手动打开文件: $HTML_MANUAL${NC}"
            fi
            wait_for_key
            ;;
        2)
            show_cli_manual
            wait_for_key
            ;;
        3)
            show_header
            echo -e "${YELLOW}工具使用方法${NC}"
            echo ""
            echo -e "${GREEN}1. 赋予执行权限:${NC}"
            echo -e "   ${CYAN}chmod +x $SCRIPT_NAME${NC}"
            echo ""
            echo -e "${GREEN}2. 运行交互模式:${NC}"
            echo -e "   ${CYAN}./$SCRIPT_NAME${NC}"
            echo ""
            echo -e "${GREEN}3. 运行API模式:${NC}"
            echo -e "   ${CYAN}./$SCRIPT_NAME --type file --target ./test --quantity 5 --name test${NC}"
            echo ""
            echo -e "${GREEN}4. 获取帮助:${NC}"
            echo -e "   ${CYAN}./$SCRIPT_NAME --help${NC}"
            echo ""
            wait_for_key
            ;;
        4)
            show_header
            echo -e "${YELLOW}系统依赖检查${NC}"
            echo ""
            check_dependencies
            wait_for_key
            ;;
        5)
            show_header
            script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            echo -e "${YELLOW}脚本信息${NC}"
            echo ""
            echo -e "${CYAN}脚本位置:${NC} $script_dir/$SCRIPT_NAME"
            echo -e "${CYAN}手册位置:${NC} $script_dir/$MANUAL_SCRIPT"
            echo ""
            echo -e "${GREEN}目录内容:${NC}"
            ls -la "$script_dir" | head -10
            echo ""
            echo -e "${YELLOW}是否在文件管理器中打开此目录? (y/n):${NC}"
            read -p "选择: " open_dir
            if [ "$open_dir" = "y" ] || [ "$open_dir" = "Y" ]; then
                if command_exists xdg-open; then
                    xdg-open "$script_dir" 2>/dev/null &
                elif command_exists open; then
                    open "$script_dir" 2>/dev/null &
                else
                    echo -e "${RED}无法打开文件管理器${NC}"
                fi
            fi
            wait_for_key
            ;;
        0)
            echo -e "${GREEN}感谢使用增强版文件创建工具！${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}无效选择，请重新输入${NC}"
            wait_for_key
            ;;
    esac
}

# 函数：检查系统依赖
check_dependencies() {
    echo -e "${CYAN}检查系统依赖...${NC}"
    echo ""
    
    local all_ok=true
    
    # 检查主要命令
    for cmd in mkdir touch ls chmod; do
        if command_exists "$cmd"; then
            echo -e "${GREEN}✅ $cmd${NC}"
        else
            echo -e "${RED}❌ $cmd${NC}"
            all_ok=false
        fi
    done
    
    # 检查浏览器命令
    echo ""
    echo -e "${CYAN}浏览器支持:${NC}"
    local browser_found=false
    for browser in xdg-open open firefox google-chrome chromium-browser; do
        if command_exists "$browser"; then
            echo -e "${GREEN}✅ $browser${NC}"
            browser_found=true
        fi
    done
    
    if [ "$browser_found" = false ]; then
        echo -e "${YELLOW}⚠ 未找到浏览器命令，手册将无法自动打开${NC}"
    fi
    
    # 检查网络工具
    echo ""
    echo -e "${CYAN}网络工具:${NC}"
    if command_exists curl; then
        echo -e "${GREEN}✅ curl${NC} (远程操作支持)"
    else
        echo -e "${YELLOW}⚠ curl 未安装，远程操作功能受限${NC}"
    fi
    
    if command_exists wget; then
        echo -e "${GREEN}✅ wget${NC} (备用远程工具)"
    fi
    
    echo ""
    if [ "$all_ok" = true ] && [ "$browser_found" = true ]; then
        echo -e "${GREEN}✅ 所有依赖满足，工具可以正常运行${NC}"
    else
        echo -e "${YELLOW}⚠ 部分依赖缺失，某些功能可能受限${NC}"
    fi
}

# 函数：等待用户按键
wait_for_key() {
    echo ""
    echo -e "${BLUE}按任意键返回主菜单...${NC}"
    read -n 1
}

# 主程序
main() {
    # 检查命令行参数
    if [ $# -gt 0 ]; then
        case $1 in
            --help|-h)
                show_header
                echo -e "${YELLOW}手册脚本使用方法:${NC}"
                echo ""
                echo -e "  ${CYAN}./$MANUAL_SCRIPT${NC}          显示交互式菜单"
                echo -e "  ${CYAN}./$MANUAL_SCRIPT --browser${NC} 直接在浏览器中打开手册"
                echo -e "  ${CYAN}./$MANUAL_SCRIPT --cli${NC}     显示命令行参考"
                echo -e "  ${CYAN}./$MANUAL_SCRIPT --check${NC}   检查系统依赖"
                echo -e "  ${CYAN}./$MANUAL_SCRIPT --help${NC}    显示此帮助信息"
                echo ""
                exit 0
                ;;
            --browser|-b)
                open_browser_manual
                exit 0
                ;;
            --cli|-c)
                show_cli_manual
                exit 0
                ;;
            --check)
                check_dependencies
                exit 0
                ;;
            *)
                echo -e "${RED}未知参数: $1${NC}"
                echo "使用 --help 查看可用参数"
                exit 1
                ;;
        esac
    fi
    
    # 交互式主循环
    while true; do
        show_main_menu
    done
}

# 运行主程序
main "$@"