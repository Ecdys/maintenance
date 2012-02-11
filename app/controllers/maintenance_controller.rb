class MaintenanceController < ApplicationController
  
  autocomplete :target_tag, :name  
  
  def humanize
    tags = Tag.all
    tags.each do |tag|
      tag.name = tag.name.humanize
      tag.save
    end
    respond_to do |format|
      format.js
    end
  end
  
  def add_target_tag
    @tag_name = Tag.find(params[:id]).name.humanize
    @context = params[:context]
    @target_tag = TargetTag.where(:name => @tag_name).first_or_create!(:context => @context)
    respond_to do |format|
      format.js
    end
  end
  
  def scan_tag
    if params[:id].nil?
      @tag = Tag.first
    else
      @tag = Tag.where("id >= #{params[:id]}").first
      if @tag.nil?
        @tag = Tag.first
      end
    end
    @similar_tags = Tag.search @tag.name, :match_mode => :any
    @target_tags = TargetTag.all
    @change_tags = TagRule.where(:name => @tag.name)
    @companies_skill = Company.tagged_with(@tag.name, :on => :skill_tags, :any => true)
    @companies_skill_count = @companies_skill.count
    @companies_sector = Company.tagged_with(@tag.name, :on => :sectoral_tags, :any => true)
    @companies_sector_count = @companies_sector.count
    @proposals = Proposal.tagged_with(@tag.name)
    @proposals_count = @proposals.count
    @target = TargetTag.find_by_name(@tag.name)
    
  end
  
  def add_rule
    @from = params[:from]
    @old_tag = Tag.find(@from)
    @target = params[:target]
    @rule = params[:rule]
    @tag_rule = TagRule.new
    @tag_rule.name = @old_tag.name
    @tag_rule.target_tag_id = @target
    @tag_rule.rule = @rule
    logger.debug  "rule -------> #{@rule}"
    if not @target.blank? or @rule == "Supprimer"
      @tag_rule.save
    end
    
    redirect_to :action => "scan_tag", :id => @from
     
  end
  
  def convert_tags
    tag_rules = TagRule.all
    tag_rules.each do |elem|
      old_tag = elem.name
      rule = elem.rule
      tag = Tag.find_by_name(old_tag)
    
      # si le tag existe : traduction puis suppression
      if not tag.nil?
        if rule ==  "Supprimer"
          destroy_tag(tag) 
        else
          new_tag = TargetTag.find(elem.target_tag_id).name  
          
          if rule ==  "Remplacer par"   
            add_or_rename_tag(old_tag, new_tag, "rename")
            tag.destroy
          else rule ==  "Ajouter" 
            add_or_rename_tag(old_tag, new_tag, "add")         
          end
           
        end
      end
    end
    
    respond_to do |format|
      format.js
    end
  end

  def remove_tag
    tag = Tag.find(params[:id])
    destroy_tag(tag)
    
    respond_to do |format|
      format.js
    end
    
  end 

  def rename_tag
    tag = Tag.find(params[:id])
    old_tag = tag.name
    new_tag = params[:new_name]
    add_or_rename_tag(old_tag, new_tag, "rename")
    
    tag.destroy
 
    respond_to do |format|
      format.js
    end
  end

# on vérifie toutes les occurences de tags lors des modifications ou suppressions

  
  def add_or_rename_tag(old_tag, new_tag, action)
    companies = Company.tagged_with(old_tag, :on => :skill_tags, :any => true)  
    companies.each do |company|
      if action == "rename"
        company.skill_tag_list.remove(old_tag)
      end
      company.skill_tag_list.add(new_tag, :parse => true)
      company.save
    end
    
    companies = Company.tagged_with(old_tag, :on => :sectoral_tags, :any => true)
    companies.each do |company|
      if action == "rename"
        company.sectoral_tag_list.remove(old_tag)
      end
      company.sectoral_tag_list.add(new_tag, :parse => true)
      company.save
    end
    
    
    proposals = Proposal.tagged_with(old_tag, :on => :skill_tags, :any => true)
    proposals.each do |proposal|
      if action == "rename"
        proposal.skill_tag_list.remove(old_tag)
      end
      proposal.skill_tag_list.add(new_tag, :parse => true)
      proposal.save
    end
   
    proposals = Proposal.tagged_with(old_tag, :on => :sectoral_tags, :any => true)
    proposals.each do |proposal|
      if action == "rename"
        proposal.sectoral_tag_list.remove(old_tag)
      end
      proposal.sectoral_tag_list.add(new_tag, :parse => true)
      proposal.save
    end
    
    # on regarde si ce tag était normalisé pour renommer également celui-ci

    @target_tag = TargetTag.where(:name => old_tag).first
    if not @target_tag.nil?
      @target_tag.name = new_tag
      @target_tag.save
    end
    
    
  end
    
    
    def destroy_tag(tag)
      tag_name = tag.name
      companies = Company.tagged_with(tag_name)
      companies.each do |company|
        company.skill_tag_list.remove(tag_name)
        company.sectoral_tag_list.remove(tag_name)
        company.save
      end
      
      proposals = Proposal.tagged_with(tag_name)
      proposals.each do |proposal|
        proposal.skill_tag_list.remove(tag_name)
        proposal.sectoral_tag_list.remove(tag_name)
        proposal.save
      end
      
      @target_tag = TargetTag.where(:name => @tag_name).first
      # on regarde si ce tag était normalisé pour supprimer également celui-ci
      if not @target_tag.nil?
        @target_tag.destroy
      end
      
      tag.destroy
          
    end  

end
