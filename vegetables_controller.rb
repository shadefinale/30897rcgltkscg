class VegetablesController < ApplicationController

  # When accessing from a model, use the Singular version of the model name.
  def index
    @vegetables = Vegetable.all
  end

  # We'll allow the user to search by name as well.
  def show
    @vegetable = Vegetable.find_by(name: params[:name]) if params[:name]
    # If they aren't searching by name then assume they're searching by ID.
    @vegetable ||= Vegetable.find(params[:id])
  end

  # This should be fine since the new view will want to use
  # the vegetable instance variable.
  def new
    @vegetable = Vegetable.new
  end


  # You will probably want to add a flash message here.
  # Also, you can render :new instead and it will keep the
  # previously filled out forms.
  # Finally, use if else so we only have one flashed message.
  def create
    @vegetable = Vegetable.new(whitelisted_vegetable_params)
    if @vegetable.save
      flash[:success] = "That sounds like a tasty vegetable!"
      redirect_to @vegetable
    else
      flash[:error] = "I don't think THAT is a vegetable."
      render :new
    end
  end

  # Whitelisted params are for when you pass a hash into
  # the new method of a model, not for when you're trying
  # to find something by one attribute.
  # We can use find_by for a specific attribute,
  # or just find for an id.
  def edit
    @vegetable = Vegetable.find(params[:id])
  end

  # If you're trying to find a vegetable, you need to use
  # find rather than new.
  # Similarly to edit, you use an id rather than the whitelisted params hash.
  def update
    @vegetable = Vegetable.find(params[:id])
    if @vegetable.update
      flash[:success] = "A new twist on an old favorite!"
      redirect_to @vegetable
    else
      flash[:error] = "Something is rotten here..."
      render :edit
    end
  end

  # When you are deleting a vegetable, you likely want to add
  # an error message when it doesn't work.
  # I guess also technically vegetable doesn't need to be an instance
  # variable since there's no view that will access it.
  def delete
    vegetable = Vegetable.find(params[:id])
    if vegetable.destroy
      flash[:success] = "That veggie is trashed."
    else
      flash[:error] = "That vegetable is indestructible?!"
    end
    # We'll just bring the user back to the list of vegetables
    # regardless of the outcome.
    redirect_to vegetables_path
  end

  private

    # You have to call require from params.
    # Also, indent methods under private.
    def whitelisted_vegetable_params
      params.require(:vegetable).permit(:name, :color, :rating, :latin_name)
    end

end
