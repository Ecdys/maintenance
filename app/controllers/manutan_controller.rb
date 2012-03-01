class ManutanController < ApplicationController
  
  def batch_parse_manutan

    @parts = ManutanPart.where("id > 3598")
    @parts.each do |part|
      @ref = part.code_article
      @price = get_price(@ref)
      part.online_price = @price
      part.save
    end
  end
    
  def parse_manutan
    if params[:ref].nil?
      @ref = "1004M11"
    else
      @ref = params[:ref]
    end
    @price = get_price(@ref)
  end
  
  
  def get_price(ref)  
    prix = 0
    str = "http://www.manutan.fr/is-bin/INTERSHOP.enfinity/eCS/MAF/fr_FR/-/EUR/N_SearchExalead-Start;=?_q=#{@ref}+&SearchKeywords=#{@ref}+"
    hdrs = {"User-Agent"=>"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1", "Accept-Charset"=>"utf-8", "Accept"=>"text/html"}
    my_html = ""
    open(str, hdrs).each {|s| my_html << s}
    page = my_html.force_encoding("UTF-8")
    @doc = Hpricot(page) 
    
    
    @result = @doc.search(".proVariationtdglobal").search('//text()')
    @result -= @result.search('//script/text()')
    indice = 0
    tab = Array.new
    i = -1
    @result.each do |ref|
      i += 1
      if (i % 7 == 0)
        texto = ref.inner_text.strip
        tab << texto
        logger.debug "The object is #{texto}"
        if texto == @ref
          indice = i/7
          logger.debug "The indice is #{indice}"
        end
      end
    end
    i = 0
    @doc.search(".textResult").each do |price|
      if (i == indice)
        prix_text = price.inner_html
        prix = string_to_float(prix_text)
        logger.debug "The prix is #{prix}"
      end
      i += 1
    end 
    return prix  
  end
  
end