# frozen_string_literal: true

require 'pry'
require 'dotenv/load'
require 'httparty'

class AIDevsClient
  include HTTParty
  base_uri ENV['AI_DEVS_API']

  attr_reader :task_name, :task

  def initialize(task_name)
    @task_name = task_name
  end

  def take_task
    @task = self.class.get("/task/#{auth_token}")
  end

  def answer_task(answer)
    self.class.post(
      "/answer/#{auth_token}",
      body: answer_payload(answer).to_json,
      headers: default_headers
    )
  end

  private

  def auth_token
    @auth_token ||= self.class.post(
      "/token/#{task_name}",
      body: auth_payload.to_json,
      headers: default_headers
    )['token']
  end

  def answer_payload(answer)
    {
      'answer' => answer
    }
  end

  def auth_payload
    {
      'apikey' => ENV['AI_DEVS_KEY']
    }
  end

  def default_headers
    {
      'Content-Type' => 'application/json'
    }
  end
end

class OpenAI
  include HTTParty
  base_uri ENV['OPENAI_API']

  private

  def default_headers
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}"
    }
  end
end

class ModerationsAPI < OpenAI
  def check(input)
    self.class.post(
      '/v1/moderations',
      body: payload(input).to_json,
      headers: default_headers
    )
  end

  private

  def payload(input)
    {
      'input' => input
    }
  end
end
