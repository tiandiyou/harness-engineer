#!/bin/bash

#=================================================================
# 华为项目 CI/CD 快速部署脚本
# 适用于开发/测试环境快速部署
#=================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
PROJECT_NAME="huawei-sdlo-demo"
DOCKER_REGISTRY="harbor.huawei.com"
VERSION=${1:-"latest"}
ENV=${2:-"dev"}

# 打印函数
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 帮助信息
show_help() {
    echo "用法: $0 [版本号] [环境]"
    echo ""
    echo "示例:"
    echo "  $0                  # 默认部署 latest 到 dev 环境"
    echo "  $0 v1.0.0 test      # 部署 v1.0.0 到 test 环境"
    echo "  $0 v1.0.0 prod      # 部署 v1.0.0 到 prod 环境"
    echo ""
    echo "环境选项: dev, test, prod"
}

# 检查依赖
check_dependencies() {
    print_info "检查依赖..."
    
    local deps=("docker" "kubectl" "mvn" "git")
    for dep in "${deps[@]}"; do
        if ! command -v $dep &> /dev/null; then
            print_warning "$dep 未安装"
        else
            print_success "$dep 已安装: $($dep --version | head -1)"
        fi
    done
}

# 构建项目
build_project() {
    print_info "构建项目..."
    
    mvn clean package -DskipTests
    print_success "项目构建完成"
}

# 构建Docker镜像
build_image() {
    print_info "构建Docker镜像..."
    
    local image_name="${DOCKER_REGISTRY}/${PROJECT_NAME}:${VERSION}"
    
    docker build -t ${image_name} .
    docker tag ${image_name} ${DOCKER_REGISTRY}/${PROJECT_NAME}:latest
    
    print_success "镜像构建完成: ${image_name}"
}

# 推送镜像
push_image() {
    print_info "推送镜像到仓库..."
    
    local image_name="${DOCKER_REGISTRY}/${PROJECT_NAME}:${VERSION}"
    
    docker push ${image_name}
    docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}:latest
    
    print_success "镜像推送完成"
}

# 部署到Kubernetes
deploy_k8s() {
    print_info "部署到Kubernetes (${ENV})..."
    
    # 根据环境选择配置
    local config_file="k8s/${ENV}/deployment.yaml"
    
    if [ ! -f "$config_file" ]; then
        print_error "配置文件不存在: ${config_file}"
        exit 1
    fi
    
    # 替换镜像版本
    sed -i "s|image: .*:latest|image: ${DOCKER_REGISTRY}/${PROJECT_NAME}:${VERSION}|g" ${config_file}
    
    # 应用部署
    kubectl apply -f ${config_file}
    
    # 等待部署完成
    print_info "等待Pod启动..."
    kubectl rollout status deployment/${PROJECT_NAME} -n ${ENV}
    
    print_success "部署完成"
}

# 运行测试
run_tests() {
    print_info "运行测试..."
    
    mvn test
    
    if [ $? -eq 0 ]; then
        print_success "所有测试通过"
    else
        print_error "测试失败"
        exit 1
    fi
}

# 回滚
rollback() {
    print_info "回滚到上一个版本..."
    
    kubectl rollout undo deployment/${PROJECT_NAME} -n ${ENV}
    kubectl rollout status deployment/${PROJECT_NAME} -n ${ENV}
    
    print_success "回滚完成"
}

# 查看状态
status() {
    print_info "检查部署状态..."
    
    echo ""
    echo "=== Pod 状态 ==="
    kubectl get pods -n ${ENV} -l app=${PROJECT_NAME}
    
    echo ""
    echo "=== 服务状态 ==="
    kubectl get svc -n ${ENV} -l app=${PROJECT_NAME}
    
    echo ""
    echo "=== 最近日志 ==="
    kubectl logs -n ${ENV} -l app=${PROJECT_NAME} --tail=20
}

# 主函数
main() {
    echo "======================================"
    echo "  华为项目 CI/CD 部署脚本"
    echo "======================================"
    echo ""
    
    # 解析参数
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        rollback)
            rollback
            exit 0
            ;;
        status)
            status
            exit 0
            ;;
    esac
    
    # 执行流程
    check_dependencies
    build_project
    build_image
    push_image
    deploy_k8s
    status
    
    print_success "部署完成!"
}

main "$@"