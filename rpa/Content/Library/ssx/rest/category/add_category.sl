########################################################################################################################
#!!
#! @description: Adds an SSX category.
#!
#! @input token: X-CSRF-TOKEN obtained from get_token flow
#!!#
########################################################################################################################
namespace: ssx.rest.category
flow:
  name: add_category
  inputs:
    - token
    - name
    - description
    - background_id
    - icon_id
  workflow:
    - http_client_action:
        do:
          tools.http_client_action:
            - url: "${'%s/rest/v0/categories' % get_sp('ssx_url')}"
            - method: POST
            - body: |-
                ${'''
                  {
                    "name": "%s",
                    "description": "%s",
                    "backgroundId": %s,
                    "iconId": %s
                  }
                ''' % (name, description, background_id, icon_id)}
            - headers: "${'''X-CSRF-TOKEN: %s''' % token}"
            - use_cookies: 'true'
        publish:
          - category_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${category_json}'
            - json_path: $.id
        publish:
          - id: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - id: '${id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 80
        'y': 80
      json_path_query:
        x: 226
        'y': 87
        navigate:
          4390a84b-69ef-f916-11a3-8a745f6ef87f:
            targetId: 0fc33028-6982-ffb4-682f-4b28028d19fe
            port: SUCCESS
    results:
      SUCCESS:
        0fc33028-6982-ffb4-682f-4b28028d19fe:
          x: 381
          'y': 83