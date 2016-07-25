# encoding: utf-8

#  Copyright (c) 2008-2016, Puzzle ITC GmbH. This file is part of
#  Cryptopus and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/cryptopus.

class ApiController < ApplicationController

  def render_json(data = nil)
    data = ActiveModelSerializers::SerializableResource.new(data).as_json
    render status: response_status, json: {data: data, messages: messages}
  end

  protected
  def add_error(msg)
    messages[:errors] << msg
  end

  def add_info(msg)
    messages[:info] << msg
  end

  private

  def messages
    @messages ||=
      { errors: [], info: [] }
  end

  def response_status
    @response_status ? @response_status : success_or_error
  end

  def success_or_error
    messages[:errors].present? ? :internal_server_error : nil
  end
end
