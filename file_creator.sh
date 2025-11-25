#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 函数：显示标题
show_header() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                文件/文件夹批量创建工具                  ║"
    echo "║                Batch File/Folder Creator                ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# 函数：显示错误信息
show_error() {
    echo -e "${RED}错误: $1${NC}" >&2
    echo "按任意键继续..."
    read -n 1
}

# 函数：显示成功信息
show_success() {
    echo -e "${GREEN}成功: $1${NC}"
}

# 函数：显示信息
show_info() {
    echo -e "${BLUE}信息: $1${NC}"
}

# 函数：选择创建类型
select_type() {
    while true; do
        show_header
        echo -e "${YELLOW}请选择要创建的类型:${NC}"
        echo -e "${GREEN}1. 文件 (File)${NC}"
        echo -e "${BLUE}2. 文件夹 (Folder)${NC}"
        echo -e "${PURPLE}3. 退出程序${NC}"
        echo ""
        read -p "请输入选择 (1-3): " choice
        
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

# 函数：获取创建数量
get_quantity() {
    while true; do
        show_header
        echo -e "${YELLOW}步骤 2/4 - 设置创建数量${NC}"
        echo ""
        echo -e "目标文件夹: ${CYAN}$TARGET_FOLDER${NC}"
        echo -e "创建类型: ${CYAN}$TYPE_NAME${NC}"
        echo ""
        echo "请输入要创建的$TYPE_NAME数量:"
        read -p "数量 (1-1000): " quantity
        
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
        
        # 检查范围
        if [ "$quantity" -lt 1 ] || [ "$quantity" -gt 1000 ]; then
            show_error "数量必须在 1-1000 之间！"
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
        echo -e "目标文件夹: ${CYAN}$TARGET_FOLDER${NC}"
        echo -e "创建类型: ${CYAN}$TYPE_NAME${NC}"
        echo -e "创建数量: ${CYAN}$QUANTITY${NC}"
        echo ""
        echo "请输入${TYPE_NAME}基础名称:"
        echo -e "(可以使用前缀，如 ${GREEN}document${NC}, ${GREEN}image${NC}, ${GREEN}backup${NC} 等)"
        read -p "基础名称: " base_name
        
        if [ -z "$base_name" ]; then
            if [ "$CREATE_TYPE" = "file" ]; then
                base_name="file"
            else
                base_name="folder"
            fi
        fi
        
        # 获取后缀名（仅对文件）
        if [ "$CREATE_TYPE" = "file" ]; then
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
        
        BASE_NAME="$base_name"
        EXTENSION="$extension"
        return 0
    done
}

# 函数：确认并执行创建
confirm_and_create() {
    while true; do
        show_header
        echo -e "${YELLOW}步骤 4/4 - 确认创建${NC}"
        echo ""
        echo -e "${CYAN}创建详情:${NC}"
        echo -e "目标文件夹: ${GREEN}$TARGET_FOLDER${NC}"
        echo -e "创建类型: ${GREEN}$TYPE_NAME${NC}"
        echo -e "创建数量: ${GREEN}$QUANTITY${NC}"
        echo -e "基础名称: ${GREEN}$BASE_NAME${NC}"
        if [ "$CREATE_TYPE" = "file" ]; then
            echo -e "文件后缀: ${GREEN}${EXTENSION:-无}${NC}"
        fi
        echo ""
        echo -e "将创建以下${TYPE_NAME}:"
        
        # 显示前5个示例
        for ((i=1; i<=5 && i<=QUANTITY; i++)); do
            if [ "$CREATE_TYPE" = "file" ]; then
                echo -e "  ${BLUE}$TARGET_FOLDER/${BASE_NAME}${i}${EXTENSION}${NC}"
            else
                echo -e "  ${BLUE}$TARGET_FOLDER/${BASE_NAME}${i}${NC}"
            fi
        done
        
        if [ "$QUANTITY" -gt 5 ]; then
            echo -e "  ${YELLOW}... 以及另外 $((QUANTITY-5)) 个${TYPE_NAME}${NC}"
        fi
        
        echo ""
        echo -e "${PURPLE}是否确认创建? (y/n):${NC}"
        read -p "确认: " confirm
        
        case $confirm in
            y|Y)
                create_items
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

# 函数：执行创建操作
create_items() {
    echo ""
    echo -e "${YELLOW}正在创建${TYPE_NAME}...${NC}"
    
    local success_count=0
    local fail_count=0
    
    for ((i=1; i<=QUANTITY; i++)); do
        if [ "$CREATE_TYPE" = "file" ]; then
            filename="$TARGET_FOLDER/${BASE_NAME}${i}${EXTENSION}"
            if touch "$filename" 2>/dev/null; then
                echo -e "  ${GREEN}✓ 创建文件: ${BASE_NAME}${i}${EXTENSION}${NC}"
                ((success_count++))
            else
                echo -e "  ${RED}✗ 创建失败: ${BASE_NAME}${i}${EXTENSION}${NC}"
                ((fail_count++))
            fi
        else
            foldername="$TARGET_FOLDER/${BASE_NAME}${i}"
            if mkdir -p "$foldername" 2>/dev/null; then
                echo -e "  ${GREEN}✓ 创建文件夹: ${BASE_NAME}${i}${NC}"
                ((success_count++))
            else
                echo -e "  ${RED}✗ 创建失败: ${BASE_NAME}${i}${NC}"
                ((fail_count++))
            fi
        fi
    done
    
    echo ""
    if [ $fail_count -eq 0 ]; then
        show_success "完成！成功创建 $success_count 个$TYPE_NAME"
    else
        show_error "创建完成！成功: $success_count, 失败: $fail_count"
    fi
    
    echo ""
    echo "按任意键继续..."
    read -n 1
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
                if select_type && \
                   get_target_folder && \
                   get_quantity && \
                   get_filename && \
                   confirm_and_create; then
                    : # 创建成功，继续循环
                else
                    show_info "操作已取消"
                fi
                ;;
            2)
                show_instructions
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

# 函数：显示使用说明
show_instructions() {
    show_header
    echo -e "${YELLOW}使用说明${NC}"
    echo ""
    echo -e "${CYAN}功能概述:${NC}"
    echo "  本工具用于批量创建文件或文件夹，提供友好的可视化交互界面。"
    echo ""
    echo -e "${CYAN}使用步骤:${NC}"
    echo "  1. 选择创建类型（文件或文件夹）"
    echo "  2. 指定目标文件夹路径"
    echo "  3. 设置创建数量"
    echo "  4. 设置文件/文件夹名称"
    echo "  5. 确认并创建"
    echo ""
    echo -e "${CYAN}特色功能:${NC}"
    echo "  • 彩色可视化界面"
    echo "  • 实时路径验证"
    echo "  • 自动创建不存在的目录"
    echo "  • 创建前预览示例"
    echo "  • 详细的成功/失败报告"
    echo ""
    echo -e "${CYAN}注意事项:${NC}"
    echo "  • 确保对目标文件夹有写入权限"
    echo "  • 数量限制为 1-1000 个"
    echo "  • 如遇重名文件，将被覆盖"
    echo ""
    echo "按任意键返回主菜单..."
    read -n 1
}

# 检查依赖
check_dependencies() {
    local missing_deps=()
    
    # 检查必要的命令
    for cmd in mkdir touch ls pwd; do
        if ! command -v $cmd &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}错误: 缺少必要的命令: ${missing_deps[*]}${NC}"
        exit 1
    fi
}

# 主程序
main() {
    # 检查依赖
    check_dependencies
    
    # 显示欢迎信息
    show_header
    echo -e "${GREEN}欢迎使用文件/文件夹批量创建工具！${NC}"
    echo ""
    echo "按任意键开始..."
    read -n 1
    
    # 进入主菜单
    main_menu
}

# 运行主程序
main "$@"