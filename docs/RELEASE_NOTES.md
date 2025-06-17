# Changelog

## Unreleased (2025-06-17)

### Features

* add baseline analysis for OWASP ZAP
([3649d23](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/3649d23bbb2559512f04dae8ba3e956ce2e57521))
* add promoted multipipeline in Jenkins
([cd7736d](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/cd7736d27762b8da39545e797b589b1481884cf3))
* add Bulkhead configuration for critical microservices
([49241c8](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/49241c82b7196c801c4dd4100a87bf31c34d64df))
* add external ip for Zipkin an Proxy-Client
([3cceded](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/3cceded6b593ad41288420a049123cc4467708a7))
* implement Bulkhead and Rate Limit pattern
([3153173](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/31531738594def0fa8094feb7228c6327ab9fad4))
* add Bulkhead and RateLimit pattern
([3dac11c](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/3dac11cf736a45fabed1cdb2f8fcd70afa629a08))
* dev stage for architecture as code
([317deac](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/317deac17ef7c8072b6b803644ac0c4173f5b9f3))
* add dev to environment choice
([9d1732a](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/9d1732a1b63fadfda478225189c7d86c62783a09))
* static bucket for stage
([999628c](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/999628cd9f0361d6c8474b4dce97929a8270a592))
* selection of prod or stage architecture
([45517ff](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/45517ff6d6e61117d94a9514fb6002ae92fc987a))
* add stage for upload artifacts to Nexus
([cbee3a0](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/cbee3a050d32e7e1eea1879fbd4c2f89145c6013))
* add manifiest for deploy Nexus server
([bc1718a](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/bc1718a71b29730bc5fe00e2078f3ebe06a635c9))
* add Prometheus and Grafana deployment
([9bfddf8](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/9bfddf8c0c3de4cb19606c8a5664f8a033580c81))
* add EKL stack pipeline for deployment
([0e793b0](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/0e793b05e89f3c7a933bc6b483c4ccce5a395493))
* add gitignore for terraform
([9084dfc](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/9084dfcca105cfa243f5660972f235e03ccaa61d))
* add jenkinsfile for terraform
([f79fc39](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/f79fc397e7ec54309e1053b20fd06ec665b34ad0))
* terrafrom google kuebernets deployment
([ef385eb](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/ef385eb1cfe0e5a298af14c1747dbd3b2fde4f67))
* add deploy microservices un GKE cluster
([562c96c](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/562c96c9bd1e233e5a72626fd3b42c367e53dc34))
* add publish html report of unit test coverage
([08f70a1](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/08f70a1c87660f7707b49943ac55db105b171917))
* add JaCoCo plugin for maven
([47b0155](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/47b01557c24d05af625625cbbde5cea2cb9b90da))
* add publish HTML reports of zap scanning
([6e2f99f](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/6e2f99fe86decd555e544a12c19258b596614923))
* add OWASP ZAP scanning
([fa9670e](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/fa9670ed8266c7a9566cd9b01e7b1a85a8b7c367))
* add multiplatform using flag --push
([50300a2](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/50300a2308096e15a1decb5ff7dddc35c0133db0))
* add multiplatform build for each microservice
([a34d497](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/a34d497bafa06b514ef60754b945085c167d0e90))
* elk with logstach, elasticsearch, kibana y filebeat
([34da376](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/34da37621536655bc195b68053f4674e26183f92))
* add reminder notification via email for approval deployment
([79acf39](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/79acf39435dc7f1b081d4f632ebc57ed184f738a))
* add reminder notification via email for approval deployment
([5ca14ff](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/5ca14ff071cbd518c1673970c9769259ff9751a5))
* add input approve for deploy
([99ff42f](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/99ff42fb6df0eb72e9847e32b227dfc55c2e9d6d))
* add mail notification for failure
([8213cf7](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/8213cf7eeb9fc3b001abbd8a0dc5e5405f48207c))
* add scan vulnerabilities with trivy
([e0c26d2](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/e0c26d28b79366c877fbf931c22e68500685b712))
* add sonarqube validation for clean code
([6840dbd](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/6840dbd63e30fb8e113196436bbf0996e377c3b6))
* add public endpoint for eureka sercer
([4e19bde](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/4e19bde4db8708a832962f634a5d2e4c553b9e2e))
* add visual report for E2E test
([5d4f7a0](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/5d4f7a0c43bed16ed8202bca6f32b49835c34edd))
* add visual report for integration and E2E tests
([00a712a](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/00a712a111d8808945d55e910c64048c62e9908f))
* add visual report for unit test
([d73a6e3](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/d73a6e3fd7cdb67d4e00d50079e5a960c33faa05))
* add stress reports into output workspace files
([9c5b4a7](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/9c5b4a7d87670792a1174c4482c43cf95b6c6978))
* add report for stress test in html
([868ff01](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/868ff0137b8b1a054bbf8a07c54044daf1c04335))
* add report of load test in html format
([3d9d5c3](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/3d9d5c3b2b31bd2a2a198ffd99afdd0791b5ecfe))
* add favourite, payment and shipping for deploy un kubernetes
([ddaa4d2](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/ddaa4d254917523b0f078ccddfe093d9c2c229b9))
* add deploy of order, product and order services
([58bee15](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/58bee151c7df4a8565b708c9a639e3c5314d8d37))
* add sleep time for succesfully delete of testContainers
([34e4550](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/34e455029c8805463cd7332fabaa472c59a1dbb7))
* add image with tag prod for each deployment k8s manifiest
([ff88b54](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/ff88b54db7e4a36ccb8e2ae8a384fbca865d5990))
* dinamyc aloccations of spring profile to each image
([05641f6](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/05641f6f2b9f4d467700114307dacedee1b372e8))
* add multibranching pipeline and stage for each branch
([7442403](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/744240376ca30dbbcadf24913cb0af2773e6ee13))
* add stage for autogenerated release notes in Jenkinsfile
([c2cf314](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/c2cf31474af5b5f4147550b1341a7985c9dda274))
* add all stages of the pipeline
([2c38313](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/2c383137a7aeda86e7580bd4a9038bbe37fa1932))
* add stress test with locust
([78b07ad](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/78b07adfaec1a35acf001d188a421f72bb168e0f))
* add load and stress test stage
([bdc45d2](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/bdc45d27f465196d9d1af2ec47bbab0fc2571dd1))
* add locust for load and stress test
([52befe6](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/52befe61cbcfd239b526d73071af88e394f6e80a))
* update Jenkins pipeline with all stage and test
([be1eb13](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/be1eb1342522f3ea8153b29b77175342f674682a))
* add Dockerfile for e2e test
([d0846ec](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/d0846ec4f1f49beeb056b2feaee1e785866684a1))
* add Jenkinsfile with multibranching pipeline
([d49baa7](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/d49baa7fb088e454953dbde603fa1af1c882b7e6))
* add deploy manifiest for zipkin
([22834a3](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/22834a387e8708bcfa1b3e5653ec4c0d3d16f57b))
* add deploy manifiest for api-gateway
([1d9d9fc](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/1d9d9fc9ef78e6178354464dd2129e115a4938c7))

### Fixes

* upload initial delay seconds for Readiness Probe and Liveness Probe
([d77c9dc](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/d77c9dcfc85f1bf8591c8bec74f82cfc7d42e89c))
* remove authentication required for all endpoints
([da429f8](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/da429f811965e8eafc780896b0a5b62473feff4f))
* change instace type
([dbb7751](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/dbb77515c1e90da15a65c985412c3f898e591110))
* change namespace to default for grafana and prometheus
([ec05d2d](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/ec05d2d7113310f7e652cb7e567c441559471c36))
* remove creation of bucket for circular reasons
([85be896](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/85be89677bcd4072771a2a14e3c21af43e9f4884))
* fail init prevention
([49c574d](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/49c574d15ef634b623b553c3aabf0cccc476ca3d))
* change init to init upgrade
([2908224](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/290822420c6edb7b7f23c3bb4c5f337294008eb0))
* upgrade to newest versions
([c153f4b](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/c153f4b1f9d11e71e17b87baa6bb19f3fc497bef))
* check state conflicts
([6964c6a](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/6964c6a38be4e4eb3404038d361a4945e421c3e3))
* change name to primary-node-pool and syncronize state
([bf01dd4](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/bf01dd4516f73382c59cb8957b4a66ea794ff97e))
* add labels to match current state
([11295b1](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/11295b1ca10904b2dfd4478a064974051c9f2978))
* changes to match state
([02f6cf2](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/02f6cf26a86799b4a633e8a1f392f4367036bf55))
* remove unnecesary ls
([ac95695](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/ac956955949544bbdeffdd4a760d2cd2c6697091))
* avoid unwanted changes in node pools
([241e8eb](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/241e8ebfadb7255c9db806d50af013fff1f6c672))
* remove bucket from terraform
([5802b38](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/5802b386102af29f78c7e974f3282276674b4ec1))
* change init to support failure
([492f4ff](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/492f4ff60eb1a04dca8951c1241f36f64ebae861))
* change init to reconfigure
([0e85b51](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/0e85b517496f9ed637d2f39c76a78e69081f1f72))
* elimate old tfstate and added backend.tf
([7836a05](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/7836a0590b1da65f3c84a58337235f82596f1b8c))
* prevent elimination of .terraform directory
([2965a41](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/2965a411c6336b1ff5e93b71184e617d4d1474c5))
* static storage name
([a5f2d24](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/a5f2d24a7f6f9b345e5fd5c0960fa958f57aba16))
* storage bucket last destroy
([47b79a4](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/47b79a41eb2f69758ebe23b8487ed1c1c13a3ce6))
* manage output codes for plan
([6674a04](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/6674a04abdafbf2f914d099143772edb1fcf1b66))
* root directories for terraform
([5b9c007](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/5b9c007521fb88b765cc80c2948a2cc2e372c322))
* check directories
([fbd80ba](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/fbd80ba34c213acf6d33f6ab71d5efc966358c36))
* check current directory
([919788b](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/919788baf1adcfdfb46cc84edc3e94bd8c6c6162))
* error sintax when
([9c8a151](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/9c8a151af6faa5eb0d47de5b3fb209b12af9138d))
* delete namespace harcoded in k8s manifiest
([68d4c1f](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/68d4c1fba79769aa949e4ad84260b928331d0fc4))
* delete withGcloud method
([2ed115c](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/2ed115cb326e440361e2709e282c3056cf5d998b))
* add gcloud sdk with auth plugin
([c574f75](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/c574f75c789f87cc28eaa127c55c239cd4db5b6e))
* add withGcloud method for auth in GKE
([865fae5](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/865fae546703995aceca197d4bacbbf7029fb9c8))
* add good identeation to the method
([5319a87](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/5319a87b56a8756ff7ce40a1b31d2fa768948d5a))
* add function withGcloud for ussing Gcloud SDK
([9cbfd55](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/9cbfd554c04c2b3babf96488744b91aadd540653))
* add gcloud path
([b8ba3a9](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/b8ba3a9e1178679ea541eb684bc9ba27b34fb4ba))
* add project id
([6432dc4](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/6432dc47da7a4a6184bf97af68f72f04224dc312))
* change order of stage, put firs auth in gke
([32851b0](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/32851b065f69f6c148dd65ab655ce385c82ace91))
* fixed identation
([320ddc3](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/320ddc35d500e2ab8e9536e9851ff77fd46a8aab))
* fix some errors in OWASP ZAP scan
([cb90726](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/cb907261761a3735348f0128a873de74d4395dec))
* fix oficial image url for OWASP ZAP
([9838ca3](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/9838ca364469fb56d671b090d71dde848b75fb84))
* add -p flag to mkdir command
([edd16f9](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/edd16f9a0292720642130c17faf6aff04bfb2ad0))
* add path to binary file of trivy
([7b01a1f](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/7b01a1f978e88d21a1b59216bd3407cb067ef989))
* add env for good compilation of sq
([f85d1b2](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/f85d1b23ddf21995c605968e29aa7975bd136c35))
* add pointer for target class to sonarqube
([c2fc2d2](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/c2fc2d2cba668e29c74529fcd57bf3b1833d1c25))
* add java 17 for sonarqube scanning
([b0ab693](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/b0ab693b8b532a019dac3425f1a425924f4824eb))
* add java 17 for sonarqube scanning
([277d00a](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/277d00a475272ab085ce44cf4fd4229ce2baaaa8))
* add java 17 for sonarqube scanning
([0b996d8](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/0b996d8a9231acb35ee6cf006ff944f1156a3764))
* add actions for method until
([d10a76b](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/d10a76bbcd96fdd2275f12587cc5f42bfff19a7b))
* put the junit report out of the loop
([28b1e8a](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/28b1e8ac7b718e0fb5f057e0d86c525b18e14ff0))
* fixed error for load test in favourite service
([e666a19](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/e666a1917a8648f1d222b027d5cc957abcf719c2))
* delete namespace in each service manifiest
([3b3be0d](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/3b3be0d8294135250e483ea28f3e5b6237a9553c))
* add service-discovery with configuration of eureka server
([71dad65](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/71dad657253698659cd185c9a0ec7945e3fa2452))
* modify port for good mapping
([9cf4432](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/9cf443266851b978b88a9336d33748f4da15f094))
* add spring profile var to product-service dockerfile
([b40331f](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/b40331f00955fb162cac19527b2c756f25761989))
* modify docker image for service-discovery testContainer
([4862972](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/486297246bc86796935de6d1c96cd51ada813293))
* add command for applying spring profile for deploy
([cb96df9](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/cb96df99cf067d505e12757527d462ed5fc7da00))
* fixed image name of cloud-config
([241a990](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/241a9906497fea354a749e514a7b85afd0f52169))
* change route of convco
([8f821f5](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/8f821f5d7150e4a772ef58139ce0d2c0442a8678))
* fixed identation on Jenkinsfile
([9e9bdeb](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/9e9bdeb7490c0d95200adaea52075d0aed808e64))
* change interval of order ids
([968c1e1](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/968c1e1b1af8214ffa1a8b7a3ebb878ab1b73428))
* change id for orderId in locust test
([89a2e5d](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/89a2e5d484676c848b8a2d74ed0f7d369a44c670))
* change host of favourite-service in locust test
([c057351](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/c057351456a687ba7ed5a89f2c03ee9c76913606))
* correct route of locustfile inside the container
([83f3f72](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/83f3f723c263f4e6e1f4515d587cd0017a4ba90b))
* fix docker run for locust
([ffceb67](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/ffceb67fa049a08cfda0b83ed5e8aae010f9dfc7))
* add tag image for locust image
([192a312](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/192a312ae904f1c816d6928161d4a2cf1bae33c1))
* change validation of status for each container
([148dcf1](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/148dcf13aabafa5d19e343582858b2ca9e6f6ec8))
* fix health url of each container with his context path
([c994049](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/c994049374d88ec8891d4907b5ef95534c4dd3df))
* fix identation of Jenkinsfile
([a8e267b](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/a8e267bfb7d6e3660222897cc344267324070893))
* fix identation of Jenkinsfile
([8c51481](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/8c5148136ec3bae5c5151f14717696ecf5d4fb3d))
* delete api-gateway container for testing
([9053a4a](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/9053a4aa789f2a9d5f6b7221d3866fbcfba5d56c))
* add -t argument for build images stage
([6348af7](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/6348af79a712d6bf86175d3b552a12b48eae481c))
* change initialDelaySeconds and liveness probe var for services health
([c59960d](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/c59960d0356f32f8f32b4ba31410c69e4cb26574))
* change initialDelaySeconds var for service-discovery health
([dbadf3f](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/dbadf3f71f78f9d94693c294847bbdfcd73e3841))
* change uri in eureka route
([42b4f51](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/42b4f51f3574f52a42e6dacdd84e1d9512b032cc))
* change filter in eureka route
([5408e7e](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/5408e7ef12f24c1946872f1f81c0f77944b33b0d))
* change filter in zipkin route
([ebcc9d2](https://github.com/JacoboOssa/ecommerce-microservice-backend-app/commit/ebcc9d29326cfa2ba3be60df5ab59c02db76d656))
