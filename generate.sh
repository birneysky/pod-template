export XCODE_PROJECT_NAME='JiaoJiao'
export XCODE_PROJECT_APP_NAME=${XCODE_PROJECT_NAME}_Example
export XCODE_PROJECT_NAME_TEST=${XCODE_PROJECT_NAME}Tests
mkdir ${XCODE_PROJECT_APP_NAME}
mkdir ${XCODE_PROJECT_NAME}
mkdir ${XCODE_PROJECT_NAME_TEST}
cp -f ~/source/github/pod-template/project.yml ./
xcodegen
rm -rf ./project.yml
#rm -rf ${XCODE_PROJECT_APP_NAME}
#rm -rf ${XCODE_PROJECT_NAME}
#rm -rf ${XCODE_PROJECT_NAME}.xcodeproj
#rm -rf ${XCODE_PROJECT_NAME_TEST}
