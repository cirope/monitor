# frozen_string_literal: true

worker_processes 1
listen ENV['PORT'] || 3000
timeout 60
