import requests
import json

files_in = 'somatic_file_names.txt'
cases_endpt = 'https://gdc-api.nci.nih.gov/cases'
proj_endpt = 'https://gdc-api.nci.nih.gov/projects'
    #"value": ["a0cb35f5-0d64-4fb9-9747-acf4cfc88012.htseq.counts.gz"]

out_file = open('somatic_api_data.txt', 'w')

with open(files_in) as f:
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
        response = requests.get(cases_endpt, params=params)

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
