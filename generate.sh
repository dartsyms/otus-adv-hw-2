MODULE_SRC=hwappsecond/NetworkClient
openapi-generator generate -i dummyapiio.yaml -g swift5 -o api-mobile
rm -r $MODULE_SRC""*
cp -R api-mobile/OpenAPIClient/Classes/OpenAPIs/. $MODULE_SRC
rm -r api-mobile
