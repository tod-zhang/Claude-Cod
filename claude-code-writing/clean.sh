#!/bin/bash
# 清理工作流生成的所有文件

echo "Cleaning workflow files..."

rm -f config/*.json
rm -f drafts/*.md
rm -f knowledge/*.md
rm -f outline/*.md
rm -f output/*.md

echo "Done! Cleaned:"
echo "  - config/"
echo "  - drafts/"
echo "  - knowledge/"
echo "  - outline/"
echo "  - output/"
