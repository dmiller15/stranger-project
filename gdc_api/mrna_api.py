import requests
import json

cases_endpt = 'https://gdc-api.nci.nih.gov/cases'
proj_endpt = 'https://gdc-api.nci.nih.gov/projects'
    #"value": ["a0cb35f5-0d64-4fb9-9747-acf4cfc88012.htseq.counts.gz"]

out_file = open('api_data.txt', 'w')

with open('mrna_counts.txt') as f:
    for line in f:
        f_in = line.strip().split('/')
        filt = {
        'op':'=',
        "content":{
        "field": "files.file_name",
        "value": [f_in[-1]]
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
        # res[0:n-1]['cases'][0]['samples'][0]['sample_type'] # Returns sample type of nth file associated with case ID
        # res[n]['file_name'] # Returns each file name

        n = len(res)
        i = 0
        while i < n:
            file_n = res[i]['file_name']
            if file_n == f_in[-1]:
                sample_type = res[i]['cases'][0]['samples'][0]['sample_type']
                submitter_id = res[i]['cases'][0]['submitter_id']
                project_id = res[i]['cases'][0]['project']['project_id']
                break
            else:
                i += 1
        print("%s\t%s\t%s\t%s" % (project_id,file_n, sample_type, submitter_id), file=out_file)

out_file.close()
# Query the different projects
## TCGA-*
## TARGET-*
## Accessible in response.json()['data']['hits'][*]['project_id']

'''
url = "https://gdc-api.nci.nih.gov/projects"
querystring = {"facets":"project.project_id","size":"100000"}
headers = {
'cache-control': "no-cache",
'postman-token': "ecd3de45-a057-5723-da03-31667ca52d10"
}
response = requests.request("GET", url, headers=headers, params=querystring)
print(response.text)
'''