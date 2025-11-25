#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 脚本信息
SCRIPT_NAME="enhanced_file_creator.sh"
SCRIPT_VERSION="2.0"
AUTHOR="Your Name"

# 全局变量
CREATE_TYPE=""
TYPE_NAME=""
TARGET_FOLDER=""
QUANTITY=0
BASE_NAME=""
EXTENSION=""
FILE_MODE=""
REMOTE_URL=""
REMOTE_USER=""
REMOTE_PASS=""
NON_INTERACTIVE=false
COPY_SCRIPT=true
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 函数：显示标题
show_header() {
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║               增强版文件/文件夹批量创建工具                   ║"
    echo "║              Enhanced File/Folder Creator v2.0                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# 函数：显示错误信息
show_error() {
    echo -e "${RED}错误: $1${NC}" >&2
    if [ "$NON_INTERACTIVE" = false ]; then
        echo "按任意键继续..."
        read -n 1
    fi
}

# 函数：显示成功信息
show_success() {
    echo -e "${GREEN}成功: $1${NC}"
}

# 函数：显示信息
show_info() {
    echo -e "${BLUE}信息: $1${NC}"
}

# 函数：显示警告信息
show_warning() {
    echo -e "${YELLOW}警告: $1${NC}"
}

# 函数：显示使用说明
show_usage() {
    echo -e "${CYAN}增强版文件/文件夹批量创建工具 v$SCRIPT_VERSION${NC}"
    echo ""
    echo -e "${YELLOW}使用方式:${NC}"
    echo "  $0 [选项]"
    echo ""
    echo -e "${YELLOW}交互模式:${NC}"
    echo "  不提供任何参数启动交互模式"
    echo ""
    echo -e "${YELLOW}API模式 (命令行参数):${NC}"
    echo "  --type TYPE          创建类型: file 或 folder"
    echo "  --target DIR         目标文件夹路径"
    echo "  --quantity NUM       创建数量"
    echo "  --name NAME          基础文件名"
    echo "  --extension EXT      文件后缀名 (仅文件类型)"
    echo "  --mode MODE          文件权限 (八进制, 如 755)"
    echo "  --remote-url URL     远程URL (http/https/ftp/ftps)"
    echo "  --remote-user USER   远程用户名"
    echo "  --remote-pass PASS   远程密码"
    echo "  --no-copy-script     不复制脚本到目标位置"
    echo "  --non-interactive    非交互模式"
    echo "  --help               显示此帮助信息"
    echo ""
    echo -e "${YELLOW}示例:${NC}"
    echo "  $0 --type file --target ./docs --quantity 5 --name document --extension .txt --mode 644"
    echo "  $0 --type folder --target ./projects --quantity 3 --name project --mode 755"
    echo "  $0 --type file --remote-url ftp://example.com/uploads --remote-user myuser --remote-pass mypass --name remote_file --extension .txt"
    echo ""
    echo -e "${YELLOW}文件名模板变量:${NC}"
    echo "  在名称中使用以下变量:"
    echo "    {DATE}    - 当前日期 (YYYY-MM-DD)"
    echo "    {TIME}    - 当前时间 (HH-MM-SS)"
    echo "    {DATETIME} - 当前日期时间"
    echo "    {TIMESTAMP} - 时间戳"
    echo "    {RANDOM}  - 随机数"
    echo "    {INDEX}   - 递增序号"
    echo ""
    echo -e "${YELLOW}示例:${NC}"
    echo "  --name \"backup_{DATE}_{TIME}\""
    echo "  --name \"log_{DATETIME}_{INDEX}\""
    echo "  --name \"temp_{TIMESTAMP}_{RANDOM}\""
}

# 函数：解析命令行参数
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --type)
                CREATE_TYPE="$2"
                shift 2
                ;;
            --target)
                TARGET_FOLDER="$2"
                shift 2
                ;;
            --quantity)
                QUANTITY="$2"
                shift 2
                ;;
            --name)
                BASE_NAME="$2"
                shift 2
                ;;
            --extension)
                EXTENSION="$2"
                shift 2
                ;;
            --mode)
                FILE_MODE="$2"
                shift 2
                ;;
            --remote-url)
                REMOTE_URL="$2"
                shift 2
                ;;
            --remote-user)
                REMOTE_USER="$2"
                shift 2
                ;;
            --remote-pass)
                REMOTE_PASS="$2"
                shift 2
                ;;
            --no-copy-script)
                COPY_SCRIPT=false
                shift
                ;;
            --non-interactive)
                NON_INTERACTIVE=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                show_error "未知参数: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

# 函数：检查依赖
check_dependencies() {
    local missing_deps=()
    
    # 检查必要的命令
    for cmd in mkdir touch ls pwd curl wget; do
        if ! command -v $cmd &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        show_warning "缺少一些命令: ${missing_deps[*]}"
        echo "部分功能可能无法使用。"
        if [ "$NON_INTERACTIVE" = false ]; then
            echo "按任意键继续..."
            read -n 1
        fi
    fi
}

# 函数：处理文件名模板
process_filename_template() {
    local template="$1"
    local index="$2"
    
    # 获取当前时间信息
    local current_date=$(date +%Y-%m-%d)
    local current_time=$(date +%H-%M-%S)
    local current_datetime=$(date +"%Y-%m-%d_%H-%M-%S")
    local timestamp=$(date +%s)
    local random_num=$((RANDOM % 10000))
    
    # 替换模板变量
    template="${template//\{DATE\}/$current_date}"
    template="${template//\{TIME\}/$current_time}"
    template="${template//\{DATETIME\}/$current_datetime}"
    template="${template//\{TIMESTAMP\}/$timestamp}"
    template="${template//\{RANDOM\}/$random_num}"
    template="${template//\{INDEX\}/$index}"
    
    echo "$template"
}

# 函数：选择创建类型
select_type() {
    while true; do
        show_header
        echo -e "${YELLOW}请选择要创建的类型:${NC}"
        echo -e "${GREEN}1. 文件 (File)${NC}"
        echo -e "${BLUE}2. 文件夹 (Folder)${NC}"
        echo -e "${PURPLE}3. 远程文件/文件夹 (Remote)${NC}"
        echo -e "${RED}4. 退出程序${NC}"
        echo ""
        read -p "请输入选择 (1-4): " choice
        
        case $choice in
            1)
                CREATE_TYPE="file"
                TYPE_NAME="文件"
                return 0
                ;;
            2)
                CREATE_TYPE="folder"
                TYPE_NAME="文件夹"
                return 0
                ;;
            3)
                CREATE_TYPE="remote"
                TYPE_NAME="远程文件/文件夹"
                return 0
                ;;
            4)
                echo "感谢使用，再见！"
                exit 0
                ;;
            *)
                show_error "无效选择，请重新输入！"
                ;;
        esac
    done
}

# 函数：获取目标文件夹路径
get_target_folder() {
    while true; do
        show_header
        echo -e "${YELLOW}步骤 1/4 - 选择目标文件夹${NC}"
        echo ""
        echo -e "当前工作目录: ${CYAN}$(pwd)${NC}"
        echo ""
        echo -e "请输入目标文件夹路径:"
        echo -e "(输入 ${GREEN}.${NC} 表示当前目录, ${GREEN}..${NC} 表示上级目录)"
        echo -e "(或输入 ${GREEN}ls${NC} 查看当前目录内容)"
        read -p "路径: " target_folder
        
        # 特殊命令处理
        if [ "$target_folder" = "ls" ]; then
            echo ""
            echo -e "${CYAN}当前目录内容:${NC}"
            ls -la
            echo ""
            echo "按任意键继续..."
            read -n 1
            continue
        fi
        
        # 使用当前目录
        if [ -z "$target_folder" ]; then
            target_folder="."
        fi
        
        # 检查路径是否存在
        if [ ! -d "$target_folder" ]; then
            echo ""
            read -p "文件夹不存在，是否创建? (y/n): " create_dir
            if [ "$create_dir" = "y" ] || [ "$create_dir" = "Y" ]; then
                if mkdir -p "$target_folder"; then
                    show_success "文件夹创建成功: $target_folder"
                    TARGET_FOLDER="$target_folder"
                    return 0
                else
                    show_error "无法创建文件夹，请检查权限！"
                    continue
                fi
            else
                continue
            fi
        else
            TARGET_FOLDER="$target_folder"
            return 0
        fi
    done
}

# 函数：获取远程URL信息
get_remote_info() {
    while true; do
        show_header
        echo -e "${YELLOW}步骤 1/4 - 远程连接设置${NC}"
        echo ""
        echo "支持的协议: http, https, ftp, ftps"
        echo ""
        read -p "请输入远程URL: " remote_url
        
        if [ -z "$remote_url" ]; then
            show_error "URL不能为空！"
            continue
        fi
        
        # 验证URL格式
        if [[ ! "$remote_url" =~ ^(http|https|ftp|ftps):// ]]; then
            show_error "URL必须以 http://, https://, ftp:// 或 ftps:// 开头"
            continue
        fi
        
        REMOTE_URL="$remote_url"
        
        echo ""
        echo "是否需要认证? (y/n): "
        read -p "选择: " need_auth
        
        if [ "$need_auth" = "y" ] || [ "$need_auth" = "Y" ]; then
            read -p "用户名: " remote_user
            read -s -p "密码: " remote_pass
            echo ""
            
            REMOTE_USER="$remote_user"
            REMOTE_PASS="$remote_pass"
        fi
        
        return 0
    done
}

# 函数：获取创建数量
get_quantity() {
    while true; do
        show_header
        echo -e "${YELLOW}步骤 2/4 - 设置创建数量${NC}"
        echo ""
        if [ "$CREATE_TYPE" = "remote" ]; then
            echo -e "远程URL: ${CYAN}$REMOTE_URL${NC}"
        else
            echo -e "目标文件夹: ${CYAN}$TARGET_FOLDER${NC}"
        fi
        echo -e "创建类型: ${CYAN}$TYPE_NAME${NC}"
        echo ""
        echo "请输入要创建的$TYPE_NAME数量:"
        echo -e "(输入 ${GREEN}0${NC} 表示无限制，按Ctrl+C停止)"
        read -p "数量: " quantity
        
        # 检查输入是否为空
        if [ -z "$quantity" ]; then
            show_error "数量不能为空！"
            continue
        fi
        
        # 检查是否为数字
        if ! [[ "$quantity" =~ ^[0-9]+$ ]]; then
            show_error "请输入有效的数字！"
            continue
        fi
        
        QUANTITY=$quantity
        return 0
    done
}

# 函数：获取文件名/文件夹名
get_filename() {
    while true; do
        show_header
        echo -e "${YELLOW}步骤 3/4 - 设置${TYPE_NAME}名称${NC}"
        echo ""
        if [ "$CREATE_TYPE" = "remote" ]; then
            echo -e "远程URL: ${CYAN}$REMOTE_URL${NC}"
        else
            echo -e "目标文件夹: ${CYAN}$TARGET_FOLDER${NC}"
        fi
        echo -e "创建类型: ${CYAN}$TYPE_NAME${NC}"
        echo -e "创建数量: ${CYAN}$QUANTITY${NC}"
        echo ""
        echo "请输入${TYPE_NAME}基础名称:"
        echo -e "可用模板变量: ${GREEN}{DATE}${NC}, ${GREEN}{TIME}${NC}, ${GREEN}{DATETIME}${NC}, ${GREEN}{TIMESTAMP}${NC}, ${GREEN}{RANDOM}${NC}, ${GREEN}{INDEX}${NC}"
        echo -e "示例: ${CYAN}backup_{DATE}_{TIME}${NC}, ${CYAN}log_{DATETIME}_{INDEX}${NC}"
        read -p "基础名称: " base_name
        
        if [ -z "$base_name" ]; then
            if [ "$CREATE_TYPE" = "file" ]; then
                base_name="file_{INDEX}"
            else
                base_name="folder_{INDEX}"
            fi
        fi
        
        # 获取后缀名（仅对文件）
        if [ "$CREATE_TYPE" = "file" ] || [ "$CREATE_TYPE" = "remote" ]; then
            echo ""
            echo "请输入文件后缀名:"
            echo -e "(例如: ${GREEN}.txt${NC}, ${GREEN}.log${NC}, ${GREEN}.md${NC}, 留空表示无后缀)"
            read -p "后缀名: " extension
            
            # 如果后缀名不为空且不以点开头，自动添加点
            if [ -n "$extension" ] && [[ ! "$extension" =~ ^\. ]]; then
                extension=".$extension"
            fi
        else
            extension=""
        fi
        
        # 获取文件权限
        echo ""
        echo "请输入文件/文件夹权限 (八进制):"
        echo -e "(例如: ${GREEN}755${NC} 对于可执行文件, ${GREEN}644${NC} 对于普通文件, 留空使用默认权限)"
        read -p "权限: " file_mode
        
        BASE_NAME="$base_name"
        EXTENSION="$extension"
        FILE_MODE="$file_mode"
        return 0
    done
}

# 函数：复制脚本到目标位置
copy_script_to_target() {
    if [ "$COPY_SCRIPT" = false ]; then
        return 0
    fi
    
    local target_dir=$(realpath "$TARGET_FOLDER")
    local script_dir=$(realpath "$SCRIPT_DIR")
    
    # 如果目标目录和脚本目录相同，不复制
    if [ "$target_dir" = "$script_dir" ]; then
        show_info "目标目录与脚本目录相同，跳过复制"
        return 0
    fi
    
    # 如果创建的是文件夹或多个文件，复制脚本
    if [ "$CREATE_TYPE" = "folder" ] || [ "$QUANTITY" -gt 1 ]; then
        local script_name=$(basename "$0")
        local target_script="$target_dir/$script_name"
        
        if cp "$0" "$target_script"; then
            # 设置执行权限
            chmod +x "$target_script"
            show_success "已复制脚本到: $target_script"
        else
            show_warning "无法复制脚本到目标位置"
        fi
    fi
}

# 函数：设置文件权限
set_file_permissions() {
    local file_path="$1"
    
    if [ -n "$FILE_MODE" ]; then
        if chmod "$FILE_MODE" "$file_path" 2>/dev/null; then
            echo -e "  ${GREEN}✓ 设置权限: $FILE_MODE${NC}"
        else
            echo -e "  ${YELLOW}⚠ 无法设置权限: $FILE_MODE${NC}"
        fi
    fi
}

# 函数：创建本地项目
create_local_items() {
    echo ""
    echo -e "${YELLOW}正在创建${TYPE_NAME}...${NC}"
    
    local success_count=0
    local fail_count=0
    local infinite_mode=false
    
    if [ "$QUANTITY" -eq 0 ]; then
        infinite_mode=true
        show_warning "无限模式已启用，按 Ctrl+C 停止创建"
    fi
    
    local i=1
    while true; do
        if [ "$infinite_mode" = false ] && [ "$i" -gt "$QUANTITY" ]; then
            break
        fi
        
        # 处理文件名模板
        local processed_name=$(process_filename_template "$BASE_NAME" "$i")
        
        if [ "$CREATE_TYPE" = "file" ]; then
            local filename="$TARGET_FOLDER/${processed_name}${EXTENSION}"
            if touch "$filename" 2>/dev/null; then
                echo -e "  ${GREEN}✓ 创建文件: ${processed_name}${EXTENSION}${NC}"
                set_file_permissions "$filename"
                ((success_count++))
            else
                echo -e "  ${RED}✗ 创建失败: ${processed_name}${EXTENSION}${NC}"
                ((fail_count++))
            fi
        else
            local foldername="$TARGET_FOLDER/${processed_name}"
            if mkdir -p "$foldername" 2>/dev/null; then
                echo -e "  ${GREEN}✓ 创建文件夹: ${processed_name}${NC}"
                set_file_permissions "$foldername"
                ((success_count++))
            else
                echo -e "  ${RED}✗ 创建失败: ${processed_name}${NC}"
                ((fail_count++))
            fi
        fi
        
        ((i++))
        
        # 无限模式下添加延迟，避免系统资源耗尽
        if [ "$infinite_mode" = true ]; then
            sleep 0.1
        fi
    done
    
    echo ""
    if [ $fail_count -eq 0 ]; then
        show_success "完成！成功创建 $success_count 个$TYPE_NAME"
    else
        show_error "创建完成！成功: $success_count, 失败: $fail_count"
    fi
    
    # 复制脚本到目标位置
    copy_script_to_target
}

# 函数：创建远程项目
create_remote_items() {
    echo ""
    echo -e "${YELLOW}正在创建远程${TYPE_NAME}...${NC}"
    
    local success_count=0
    local fail_count=0
    
    for ((i=1; i<=QUANTITY; i++)); do
        # 处理文件名模板
        local processed_name=$(process_filename_template "$BASE_NAME" "$i")
        local remote_path="$REMOTE_URL/${processed_name}${EXTENSION}"
        
        echo -e "  ${BLUE}尝试创建: $remote_path${NC}"
        
        # 创建临时文件用于上传
        local temp_file=$(mktemp)
        echo "Created by Enhanced File Creator" > "$temp_file"
        
        # 使用curl上传文件
        local curl_cmd="curl -s"
        
        # 添加认证信息
        if [ -n "$REMOTE_USER" ] && [ -n "$REMOTE_PASS" ]; then
            curl_cmd="$curl_cmd --user $REMOTE_USER:$REMOTE_PASS"
        fi
        
        # 执行上传
        if $curl_cmd --upload-file "$temp_file" "$remote_path" 2>/dev/null; then
            echo -e "  ${GREEN}✓ 创建成功: $remote_path${NC}"
            ((success_count++))
        else
            echo -e "  ${RED}✗ 创建失败: $remote_path${NC}"
            ((fail_count++))
        fi
        
        # 清理临时文件
        rm -f "$temp_file"
    done
    
    echo ""
    if [ $fail_count -eq 0 ]; then
        show_success "完成！成功创建 $success_count 个远程$TYPE_NAME"
    else
        show_error "创建完成！成功: $success_count, 失败: $fail_count"
    fi
}

# 函数：确认并执行创建
confirm_and_create() {
    while true; do
        show_header
        echo -e "${YELLOW}步骤 4/4 - 确认创建${NC}"
        echo ""
        echo -e "${CYAN}创建详情:${NC}"
        
        if [ "$CREATE_TYPE" = "remote" ]; then
            echo -e "远程URL: ${GREEN}$REMOTE_URL${NC}"
            if [ -n "$REMOTE_USER" ]; then
                echo -e "用户名: ${GREEN}$REMOTE_USER${NC}"
            fi
        else
            echo -e "目标文件夹: ${GREEN}$TARGET_FOLDER${NC}"
        fi
        
        echo -e "创建类型: ${GREEN}$TYPE_NAME${NC}"
        echo -e "创建数量: ${GREEN}$QUANTITY${NC}"
        echo -e "基础名称: ${GREEN}$BASE_NAME${NC}"
        
        if [ "$CREATE_TYPE" = "file" ] || [ "$CREATE_TYPE" = "remote" ]; then
            echo -e "文件后缀: ${GREEN}${EXTENSION:-无}${NC}"
        fi
        
        if [ -n "$FILE_MODE" ]; then
            echo -e "文件权限: ${GREEN}$FILE_MODE${NC}"
        fi
        
        echo ""
        echo -e "将创建以下${TYPE_NAME}:"
        
        # 显示前5个示例
        local display_count=$((QUANTITY < 5 ? QUANTITY : 5))
        for ((i=1; i<=display_count; i++)); do
            local processed_name=$(process_filename_template "$BASE_NAME" "$i")
            
            if [ "$CREATE_TYPE" = "remote" ]; then
                echo -e "  ${BLUE}$REMOTE_URL/${processed_name}${EXTENSION}${NC}"
            elif [ "$CREATE_TYPE" = "file" ]; then
                echo -e "  ${BLUE}$TARGET_FOLDER/${processed_name}${EXTENSION}${NC}"
            else
                echo -e "  ${BLUE}$TARGET_FOLDER/${processed_name}${NC}"
            fi
        done
        
        if [ "$QUANTITY" -gt 5 ]; then
            echo -e "  ${YELLOW}... 以及另外 $((QUANTITY-5)) 个${TYPE_NAME}${NC}"
        fi
        
        if [ "$QUANTITY" -eq 0 ]; then
            echo -e "  ${YELLOW}无限模式 - 将持续创建直到手动停止${NC}"
        fi
        
        echo ""
        echo -e "${PURPLE}是否确认创建? (y/n):${NC}"
        read -p "确认: " confirm
        
        case $confirm in
            y|Y)
                if [ "$CREATE_TYPE" = "remote" ]; then
                    create_remote_items
                else
                    create_local_items
                fi
                return 0
                ;;
            n|N)
                return 1
                ;;
            *)
                show_error "请输入 y 或 n！"
                ;;
        esac
    done
}

# 函数：验证API参数
validate_api_parameters() {
    # 检查必要参数
    if [ -z "$CREATE_TYPE" ]; then
        show_error "必须指定 --type 参数"
        return 1
    fi
    
    if [ "$CREATE_TYPE" != "file" ] && [ "$CREATE_TYPE" != "folder" ] && [ "$CREATE_TYPE" != "remote" ]; then
        show_error "类型必须是 'file', 'folder' 或 'remote'"
        return 1
    fi
    
    if [ -z "$QUANTITY" ]; then
        show_error "必须指定 --quantity 参数"
        return 1
    fi
    
    if [ -z "$BASE_NAME" ]; then
        show_error "必须指定 --name 参数"
        return 1
    fi
    
    # 对于远程创建，需要URL
    if [ "$CREATE_TYPE" = "remote" ] && [ -z "$REMOTE_URL" ]; then
        show_error "远程创建必须指定 --remote-url 参数"
        return 1
    fi
    
    # 对于本地创建，需要目标文件夹
    if [ "$CREATE_TYPE" != "remote" ] && [ -z "$TARGET_FOLDER" ]; then
        show_error "本地创建必须指定 --target 参数"
        return 1
    fi
    
    return 0
}

# 函数：API模式执行
execute_api_mode() {
    show_header
    echo -e "${YELLOW}API模式执行中...${NC}"
    echo ""
    
    if ! validate_api_parameters; then
        exit 1
    fi
    
    # 设置类型名称
    case "$CREATE_TYPE" in
        "file") TYPE_NAME="文件" ;;
        "folder") TYPE_NAME="文件夹" ;;
        "remote") TYPE_NAME="远程文件" ;;
    esac
    
    # 显示参数摘要
    echo -e "${CYAN}参数摘要:${NC}"
    echo -e "创建类型: ${GREEN}$TYPE_NAME${NC}"
    
    if [ "$CREATE_TYPE" = "remote" ]; then
        echo -e "远程URL: ${GREEN}$REMOTE_URL${NC}"
    else
        echo -e "目标文件夹: ${GREEN}$TARGET_FOLDER${NC}"
    fi
    
    echo -e "创建数量: ${GREEN}$QUANTITY${NC}"
    echo -e "基础名称: ${GREEN}$BASE_NAME${NC}"
    
    if [ "$CREATE_TYPE" = "file" ] || [ "$CREATE_TYPE" = "remote" ]; then
        echo -e "文件后缀: ${GREEN}${EXTENSION:-无}${NC}"
    fi
    
    if [ -n "$FILE_MODE" ]; then
        echo -e "文件权限: ${GREEN}$FILE_MODE${NC}"
    fi
    
    echo ""
    
    # 执行创建
    if [ "$CREATE_TYPE" = "remote" ]; then
        create_remote_items
    else
        create_local_items
    fi
}

# 函数：主菜单
main_menu() {
    while true; do
        show_header
        echo -e "${YELLOW}主菜单${NC}"
        echo ""
        echo -e "${GREEN}1. 开始创建文件/文件夹${NC}"
        echo -e "${BLUE}2. 查看使用说明${NC}"
        echo -e "${PURPLE}3. 退出程序${NC}"
        echo ""
        read -p "请选择操作 (1-3): " main_choice
        
        case $main_choice in
            1)
                if select_type; then
                    if [ "$CREATE_TYPE" = "remote" ]; then
                        if get_remote_info && \
                           get_quantity && \
                           get_filename && \
                           confirm_and_create; then
                            : # 创建成功
                        else
                            show_info "操作已取消"
                        fi
                    else
                        if get_target_folder && \
                           get_quantity && \
                           get_filename && \
                           confirm_and_create; then
                            : # 创建成功
                        else
                            show_info "操作已取消"
                        fi
                    fi
                fi
                ;;
            2)
                show_usage
                if [ "$NON_INTERACTIVE" = false ]; then
                    echo "按任意键返回主菜单..."
                    read -n 1
                fi
                ;;
            3)
                echo "感谢使用，再见！"
                exit 0
                ;;
            *)
                show_error "无效选择！"
                ;;
        esac
    done
}

# 主程序
main() {
    # 检查命令行参数
    if [ $# -gt 0 ]; then
        parse_arguments "$@"
        
        if [ "$NON_INTERACTIVE" = true ]; then
            execute_api_mode
            exit 0
        fi
    fi
    
    # 检查依赖
    check_dependencies
    
    # 显示欢迎信息
    show_header
    echo -e "${GREEN}欢迎使用增强版文件/文件夹批量创建工具 v$SCRIPT_VERSION！${NC}"
    echo ""
    
    if [ "$NON_INTERACTIVE" = false ]; then
        echo "按任意键开始..."
        read -n 1
    fi
    
    # 进入主菜单
    main_menu
}

# 运行主程序
main "$@"