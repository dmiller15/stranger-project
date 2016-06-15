import json
import requests

cases_endpt = 'https://gdc-api.nci.nih.gov/cases'
proj_endpt = 'https://gdc-api.nci.nih.gov/projects'
#"value": ["a0cb35f5-0d64-4fb9-9747-acf4cfc88012.htseq.counts.gz"]

filt = {
    'op':'=',
    "content":{
    "field": "files.file_name",
    "value": ['c0838555-b100-4c2b-9fcd-9b90874fe2fd.vep.reheader.vcf.gz']
    }
}

'''
filt = {
'op':'=',
"content":{
"field": "facets",
"value": "project.project_id"
}
}
'''

params = {'fields':'files.cases.project.project_id,files.cases.samples.sample_type,files.cases.submitter_id,files.file_name,case_id', 'filters':json.dumps(filt)}

# files.cases.demographic.gender
response = requests.get(cases_endpt, params=params)
#print(f_in[-1])
#print(json.dumps(response.json(), indent=2))
res = response.json()['data']['hits'][0]['files'] # Returns list of length n for each n files associated with case ID
print(res)
# res[0:n-1]['cases'][0]['samples'][0]['sample_type'] # Returns sample type of nth file associated with case ID
# res[n]['file_name'] # Returns each file name
