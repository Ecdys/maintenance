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
    @tag = Tag.find(params[:id])
    @context = params[:context]
    @target_tag = TargetTag.where(:name => @tag.name)
    if @target_tag.empty?
      @target_tag = TargetTag.new
      @target_tag.name = @tag.name.humanize
      @target_tag.context = @context
      @target_tag.save
    end
    respond_to do |format|
      format.js
    end
  end
  
  def scan_tag
    if params[:id].nil?
      @tag = Tag.first
    else
      @tag = Tag.where("id >= #{params[:id]}").first
    end
    @similar_tags = Tag.search @tag.name, :match_mode => :any
    @target_tags = TargetTag.all
    @change_tags = TagTargetTag.where(:name => @tag.name)
    @companies_skill = Company.tagged_with(@tag.name, :on => :skill_tags, :any => true)
    @companies_skill_count = @companies_skill.count
    @companies_sector = Company.tagged_with(@tag.name, :on => :sectoral_tags, :any => true)
    @companies_sector_count = @companies_sector.count
    @proposals = Proposal.tagged_with(@tag.name)
    @proposals_count = @proposals.count
    @target = TargetTag.find_by_name(@tag.name)
    
  end
  
  def add_to_translation_list
    @from = params[:from]
    @old_tag = Tag.find(@from)
    @target = params[:target]
    @rule = params[:rule]
    @tag_target = TagTargetTag.new
    @tag_target.name = @old_tag.name
    @tag_target.target_tag_id = @target
    @tag_target.rule = @rule
    if not @target.blank?
      @tag_target.save
    end
    
    redirect_to :action => "scan_tag", :id => @from
     
  end
  
  def convert_tags
    translations = TagTargetTag.all
    translations.each do |elem|
      old_tag = elem.name
      rule = elem.rule
      tag = Tag.find_by_name(old_tag)

      # si le tag existe : traduction puis suppression
      if not tag.nil?
        new_tag = TargetTag.find(elem.target_tag_id).name
        if rule ==  "Remplacer par"   
          update_tag(old_tag, new_tag)
          tag.destroy
        else
          add_tag(old_tag, new_tag)
        end
      end
    end
    
    respond_to do |format|
      format.js
    end
  end

  def remove_tag
    tag = Tag.find(params[:id])
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
    tag.destroy
    
    respond_to do |format|
      format.js
    end
    
  end 

  def rename_tag
    tag = Tag.find(params[:id])
    old_tag = tag.name
    new_tag = params[:new_name]
    update_tag(old_tag, new_tag)
    tag.destroy
 
    respond_to do |format|
      format.js
    end
  end
  
  def update_tag(old_tag, new_tag)
    companies = Company.tagged_with(old_tag, :on => :skill_tags, :any => true)
    companies.each do |company|
      company.skill_tag_list.remove(old_tag)
      company.skill_tag_list.add(new_tag, :parse => true)
      company.save
    end
    companies = Company.tagged_with(old_tag, :on => :sectoral_tags, :any => true)
    companies.each do |company|
      company.sectoral_tag_list.remove(old_tag)
      company.sectoral_tag_list.add(new_tag, :parse => true)
      company.save
    end
    
    proposals = Proposal.tagged_with(old_tag, :on => :skill_tags, :any => true)
    proposals.each do |proposal|
      proposal.skill_tag_list.remove(old_tag)
      proposal.skill_tag_list.add(new_tag, :parse => true)
      proposal.save
    end
    proposals = Proposal.tagged_with(old_tag, :on => :sectoral_tags, :any => true)
    proposals.each do |proposal|
      proposal.sectoral_tag_list.remove(old_tag)
      proposal.sectoral_tag_list.add(new_tag, :parse => true)
    proposal.save
    end
  end  


  def add_tag(old_tag, new_tag)
    companies = Company.tagged_with(old_tag, :on => :skill_tags, :any => true)
    companies.each do |company|
      company.skill_tag_list.add(new_tag, :parse => true)
      company.save
    end
    companies = Company.tagged_with(old_tag, :on => :sectoral_tags, :any => true)
    companies.each do |company|
      company.sectoral_tag_list.add(new_tag, :parse => true)
      company.save
    end
    
    proposals = Proposal.tagged_with(old_tag, :on => :skill_tags, :any => true)
    proposals.each do |proposal|
      proposal.skill_tag_list.add(new_tag, :parse => true)
      proposal.save
    end
    proposals = Proposal.tagged_with(old_tag, :on => :sectoral_tags, :any => true)
    proposals.each do |proposal|
      proposal.sectoral_tag_list.add(new_tag, :parse => true)
    proposal.save
    end
  end   
end
