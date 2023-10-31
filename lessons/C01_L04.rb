# frozen_string_literal: true

require_relative '../environment'

ai_devs_client = AIDevsClient.new('moderation')
moderations_api = ModerationsAPI.new
inputs = ai_devs_client.take_task['input']
moderations_results = []

inputs.each do |input|
  moderations_results << moderations_api.check(input)["results"].first["flagged"] ? 1 : 0
end

ai_devs_client.answer_task(moderations_results)
