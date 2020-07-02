var zone_map = {
	"us-east1": ["South Carolina,  USA",  33.84, -81.16],
	"us-east4": ["N. Virginia,  USA",  37.478397, -76.453077],
	"us-central1": ["Iowa,  USA",  41.88, -93.10],
	"us-east2": ["Ohio, USA", 40.417287, -76.453077],
	"us-west2": ["N. California, USA", 38.837522, -120.895824],
	"us-west1": ["The Dalles, Oregon, USA", 43.804133, -120.554201],
	"ca-central1": ["Montréal, Québec, Canada", 56.130366, -106.346771],
	"europe-west3": ["Frankfurt, Germany", 50.110922, 8.682127],
	"eu-north1": ["Stockholm, Sweden", 59.3293, 18.0686],
	"eu-west1": ["Ireland", 53.142367, -7.692054],
	"europe-west2": ["London, England", 51.507351, -0.127758],
	"eu-west3": ["Paris, France", 48.856614, 2.352222],
	"europe-west6": ["Zurich, Switzerland", 47.37, 8.54],
	"asia-northeast1": ["Tokyo, Japan", 35.689487, 139.691706],
	"asia-northeast2": ["Seoul, South Korea", 37.566535, 126.977969],
	"asia-northeast3": ["Osaka-Local, Japan", 34.693738, 135.502165],
	"asia-southeast1": ["Jurong West, Singapore", 1.352083, 103.819836],
	"ap-southeast2": ["Sydney, Australia", -33.86882, 151.209296],
	"asia-east2": ["Hong Kong", 22.32, 114.17],
	"ap-south1": ["Mumbai, India", 19.075984, 72.877656],
	"sa-east1": ["São Paulo, Brazil", -23.55052, -46.633309]
}

const es = require('@elastic/elasticsearch')
const esclient = new es.Client({ node: 'http://127.0.0.1:9200' })

async function esfunc() {
	const { body } = await esclient.search({
		index: 'msggen-msgs-*',
		// type: '_doc', // uncomment this line if you are using Elasticsearch ≤ 6
		body: {
			size: 0,
			query: {
				msgs: {
					filter: {
						range: {
							'@timestamp': {
                                gte: "2020-06-21T17:40:00",
                                lte: "2020-06-21T17:45:00"
							}
						}
					},
				}
			}
		}
	})

	nodes = body.aggregations.ts.nodes.buckets;

	console.log(nodes)

	// nodes.forEach((node) => {
	// 	console.log(node)
	// 	var nodeData = {};
	// 	nodeData.id = node.key.split('-')[5];
	// 	var zone = node.key.split('-')[2] + '-' + node.key.split('-')[3]
	// 	nodeData.info = { "location": zone_map[zone][0] };
	// 	nodeData.geo = { ll: [zone_map[zone][1], zone_map[zone][2]] };

	// 	Nodes.add(nodeData, null);
	// })
}

esfunc().catch((e)=>{console.log(e.body.error)})
