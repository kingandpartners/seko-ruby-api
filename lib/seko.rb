require 'seko/version'
require 'seko/client'
require 'seko/product'
require 'seko/response'
require 'seko/receipt'
require 'seko/stock'
require 'seko/order'
require 'seko/company'
require 'seko/dispatch'

module Seko

  @config = {
    token: '',
    supplier_code: '',
    supplier_description: '',
    supplier_uom: 1,
    warehouses: {}
  }

  def self.configure(opts = {})
    opts.each { |k,v| @config[k.to_sym] = v if @config.keys.include? k.to_sym }
  end

  def self.config
    @config
  end
  
end
