require 'sinatra'
require 'httparty'
require 'pry'
require_relative 'app/server'

run App::Server
