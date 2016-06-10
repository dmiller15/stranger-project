import requests
import json

cases_endpt = 'https://gdc-api.nci.nih.gov/cases'
    #"value": ['8c5cf7f4-402d-4fcb-b1a4-0fa2805020c3']

out_file = open('mirna_api_data.txt', 'w')

with open('mirna_files.test.txt') as f:
    for line in f:
        f_in = line.strip().split('/')
        filt = {
        'op':'=',
        "content":{
            "field": "files.file_id",
            "value": [f_in[-2]]
            }
        }
        params = {
            'fields':'files.file_id,files.cases.project.project_id,files.cases.samples.sample_type,files.cases.submitter_id,files.file_name,case_id',
            'filters':json.dumps(filt)
            }

        response = requests.get(cases_endpt, params=params)

        print(f_in[-2])
        #print(json.dumps(response.json(), indent=2))

        res = response.json()['data']['hits'][0]['files']

        n = len(res)
        i = 0
        while i < n:
            file_n = res[i]['file_id']
            if file_n == f_in[-2]:
                #res[0]['files'][n]['file_id'] == f_in
                project_id = res[i]['cases'][0]['project']['project_id']
                sample_type = res[i]['cases'][0]['samples'][0]['sample_type']
                submitter_id = res[i]['cases'][0]['submitter_id']
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