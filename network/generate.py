#!/usr/bin/env python
from jinja2 import Environment, FileSystemLoader
import os
env = Environment(loader=FileSystemLoader(os.path.join(os.path.dirname(__file__))))

template = env.get_template('network.j2')
output_from_parsed_template = template.render(
	regions=[
		"ap-south-1",
		"ap-southeast-1",
	]
)
# print(output_from_parsed_template)

# to save the results
with open("network.tf", "w") as fh:
    fh.write(output_from_parsed_template)
