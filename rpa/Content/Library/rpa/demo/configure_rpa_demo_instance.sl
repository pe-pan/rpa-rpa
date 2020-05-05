########################################################################################################################
#!!
#! @description: Configures a freshly installed RPA demo instance. It
#!               - configures Insight service
#!               - enables Insight service
#!               - sets general settings
#!               - sets content pack settings
#!               - deletes password lock policy
#!               - extends SSO expiration timeout
#!               - creates (or updates) SSX categories and scenarios
#!               - schedules flows to generate ROI in Dashboard
#!!#
########################################################################################################################
namespace: rpa.demo
flow:
  name: configure_rpa_demo_instance
  workflow:
    - set_insight_settings:
        do:
          rpa.central.rest.insight.set_insight_settings:
            - settings: 'host,port,dbConfiguration.dbType,dbConfiguration.host,dbConfiguration.port,dbConfiguration.username,dbConfiguration.password,dbConfiguration.dbName,dbConfiguration.passwordChanged'
            - values: 'rpa.mf-te.com,8458,POSTGRESQL,rpa.mf-te.com,5432,insight,Cloud@123,insight,true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: enable_insight_service
    - set_general_settings:
        do:
          rpa.central.rest.settings.set_general_settings:
            - settings: isUseEmptyPromptForInputs
            - values: 'true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_cp_settings
    - generate_roi_numbers:
        do:
          rpa.demo.generate_roi_numbers: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - delete_password_lock_policy:
        do:
          rpa.demo.delete_password_lock_policy: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_sso_expiration_time
    - set_cp_settings:
        do:
          rpa.central.rest.settings.set_cp_settings:
            - settings: 'cpStatisticsJobEnabled,cpExport'
            - values: 'true,true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_password_lock_policy
    - enable_insight_service:
        do:
          rpa.central.rest.insight.enable_insight_service: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_general_settings
    - set_sso_expiration_time:
        do:
          rpa.demo.set_sso_expiration_time: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_ssx_categories_and_scenarios
    - update_ssx_categories_and_scenarios:
        do:
          rpa.demo.update_ssx_categories_and_scenarios: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_demo_users
    - create_demo_users:
        do:
          rpa.demo.create_demo_users: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: generate_roi_numbers
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_insight_settings:
        x: 90
        'y': 69
      generate_roi_numbers:
        x: 571
        'y': 395
        navigate:
          94c5ba29-62d2-5b1a-e0e9-5bcdf47814b0:
            targetId: 5bd93ad7-c706-1240-ecdc-927475693aa5
            port: SUCCESS
      create_demo_users:
        x: 291
        'y': 399
      set_sso_expiration_time:
        x: 301
        'y': 260
      enable_insight_service:
        x: 233
        'y': 66
      update_ssx_categories_and_scenarios:
        x: 458
        'y': 270
      delete_password_lock_policy:
        x: 96
        'y': 260
      set_general_settings:
        x: 390
        'y': 65
      set_cp_settings:
        x: 573
        'y': 59
    results:
      SUCCESS:
        5bd93ad7-c706-1240-ecdc-927475693aa5:
          x: 802
          'y': 269
