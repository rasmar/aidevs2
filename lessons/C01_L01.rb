# frozen_string_literal: true

require_relative '../environment'

ai_devs_client = AIDevsClient.new('helloapi')
cookie = ai_devs_client.take_task['cookie']
ai_devs_client.answer_task(cookie)
