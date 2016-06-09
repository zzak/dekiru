# This file is used by Rack-based servers to start the application.

require 'rack/gc_tracer'

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
use Rack::GCTracerMiddleware, view_page_path: '/gc_tracer', filename: 'gc_tracer.log'
