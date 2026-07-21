import json
import os.path
import requests
import base64

#function
def displayText():
    try:
        print("hola")
    except Exception as exception:
        print(f"displayText() had next error: {exception}")

def update_test_result(url,token,outputdir, tc_summary, suite_summary):
    
    try:
        objeto_request = {}
        var_user = suite_summary['user']
        tmp_new_execution = suite_summary['new_execution']
        tmp_key_suite = suite_summary['keyEjecucion']
        if str(tmp_new_execution).lower() == 'false':
            objeto_request['testExecutionKey']=tmp_key_suite
            #objeto_request['summary'] = suite_summary['nombre_ejecucion']
            #objeto_request['testEnvironments'] = suite_summary['environment']
        array_test=[]
        for test in tc_summary:
            test_detail = {}
            test_detail['testKey'] = test['key']
            test_detail['start'] = "2023-03-08T20:47:35-06:00"
            test_detail['finish'] = "2023-03-08T20:50:56-06:00"
            test_detail['comment'] = ''
            test_detail['executedBy'] = var_user
            test_detail['status'] = test['status']
            evidences = []
            for ejecucion in test['ejecuciones']:
                test_detail['comment'] = test_detail['comment'] + 'Ejecución #' + ejecucion['ejecucion'] + ' Resultado: ' + ejecucion['status'] + ' Mensaje: ' + ejecucion['message'] + '. '
                for evidence_ejec in ejecucion['evidencias']:
                    path = os.path.join(outputdir, evidence_ejec['filename'])
                    with open(path, "rb") as file:
                        file_encoded = base64.b64encode(file.read())
                    encoded_string=file_encoded.decode("utf-8")
                    evidence_ejec['data'] = encoded_string
                    evidences.append(evidence_ejec)
            test_detail['evidences'] = evidences
            array_test.append(test_detail)
        objeto_request['tests'] = array_test
        
        payload = json.dumps(objeto_request)
        
        headers = {
            'Content-Type': 'application/json'
        }
        headers['Authorization'] = token

        response = requests.request(
            "POST", 
            url, 
            headers=headers, 
            data=payload
        )
        status_request = 'OK' if response.status_code==200 else 'NOK'
        json_respuesta = response.json()
        key_execution_new = ''
        if status_request == 'OK':
            key_execution_new = json_respuesta['testExecIssue']['key']
        print(f'Actualización de la ejecución: {key_execution_new}, status: {status_request} - Body Respuesta: {response.text}')
        return key_execution_new
        

    except Exception as exception:
        print(f"update_test_result() had next error: {exception}")


def update_execution_result(url,token,outputdir, suite_summary, tokenAtlassian,key_execution_new):
    try:
        print('Adjuntando evidencia a la ejecución')

        for evidence in suite_summary['evidences']:
            headers = {}
            headers['Authorization'] = token
            headers['X-Atlassian-Token'] = tokenAtlassian

            content_file = evidence['contentType']
            payload={}

            name_file = evidence['filename']
            path = os.path.join(outputdir, name_file)
            files = [
                ('file',(name_file,open(path,'rb'),content_file))
            ]
            print(f'request: url: {url} - headers: {headers} - files: {files}')
            response = requests.request(
                "POST", 
                url, 
                headers = headers, 
                data = payload,
                files = files
            )
            status_request = 'OK' if response.status_code==200 else 'NOK'
            print(f'Adjuntar evidencia en la ejecución: {key_execution_new}, status: {status_request} - Body Respuesta: {response}')


    except Exception as exception:
        print(f"update_execution_result() had next error: {exception}")
