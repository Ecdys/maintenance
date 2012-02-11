class TagRulesController < ApplicationController
  
  
  # GET /tag_rules
  # GET /tag_rules.json
  def index
    @tag_rules = TagRule.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tag_rules }
    end
  end

  # GET /tag_rules/1
  # GET /tag_rules/1.json
  def show
    @tag_rule = TagRule.find(params[:id])
  
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tag_rule }
    end
  end
  
  # GET /tag_rules/new
  # GET /tag_rules/new.json
  def new
    @tag_rule = TagRule.new
  
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag_rule }
    end
  end
  
  # GET /tag_rules/1/edit
  def edit
    @tag_rule = TagRule.find(params[:id])
  end
  
  # POST /tag_rules
  # POST /tag_rules.json
  def create
    @tag_rule = TagRule.new(params[:tag_rule])
  
    respond_to do |format|
      if @tag_rule.save
        format.html { redirect_to @tag_rule, notice: 'Tag target tag was successfully created.' }
        format.json { render json: @tag_rule, status: :created, location: @tag_rule }
      else
        format.html { render action: "new" }
        format.json { render json: @tag_rule.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /tag_rules/1
  # PUT /tag_rules/1.json
  def update
    @tag_rule = TagRule.find(params[:id])
  
    respond_to do |format|
      if @tag_rule.update_attributes(params[:tag_rule])
        format.html { redirect_to @tag_rule, notice: 'Tag target tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tag_rule.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /tag_rules/1
  # DELETE /tag_rules/1.json
  def destroy
    @tag_rule = TagRule.find(params[:id])
    @tag_rule.destroy
  
    respond_to do |format|
      format.html { redirect_to tag_rules_url }
      format.json { head :no_content }
    end
  end
  
end
