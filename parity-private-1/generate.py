#!/usr/bin/env python
from jinja2 import Environment, FileSystemLoader
import os
env = Environment(
	loader=FileSystemLoader(os.path.join(os.path.dirname(__file__))),
	keep_trailing_newline=True,
)

template = env.get_template('network.j2')
output_from_parsed_template = template.render(
	regions=[
		"eu-north-1",
		"ap-south-1",
		"eu-west-3",
		"eu-west-2",
		"eu-west-1",
		"ap-northeast-2",
		"ap-northeast-1",
		"sa-east-1",
		"ca-central-1",
		"ap-southeast-1",
		"ap-southeast-2",
		"eu-central-1",
		"us-east-1",
		"us-east-2",
		"us-west-1",
		"us-west-2",
	]
)
# print(output_from_parsed_template)

# to save the results
with open("network.tf", "w") as fh:
    fh.write(output_from_parsed_template)
