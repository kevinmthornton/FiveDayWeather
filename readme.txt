Five Day Weather Application

Description
Write a native iOS app that connects to a remote weather service and consumes the seven day forecast for a given zip code.

Specifications
	- Program efficiency: refresh the weather forecast data AT MOST every half hour 
		and only if the user is actively using the app 
	- User should be able to enter a zip code
  	- Show the 7-day forecast for that zip-code in a table view, one day per cell.
	- Tapping a cell will display forecast detail:
		date
		min temp
		max temp
		windspeed
		direction
		description

Solution
Open application to Table View Controller with text field in upper left for zip code and Get Weather button on right to call out to worldweatheronline.com and get JSON data based on zip code. Capture JSON data into a dictionary and reload table cells starting with today and going out 4 days. Once a day is tapped, set the detail view’s weather data and load detail view. Display all weather data for day tapped.

Classes
MasterViewController
	NSDictionary *weatherDict = dictionary of weather data 
	viewDidLoad
		- remove title
		- set up text field and button at top

	retrieveWeatherData
		- called when GetWeather button is tapped
		- get zip from  weatherZip text field
		- check to make sure we have a value and it is a zip code(5 digits)
			- show alert error message if something wrong
		- check to see if we already have this zip code stored in a file with it’s data
		- if the file is less than 1/2 hour old, show the data from the file
		- else call out to WeatherData to retrieve dictionary of data 
		- assign data to weatherDict
		- call [self.tableView reloadData] to display
		- tableView:cellForRowAtIndexPath: references weatherDict for days of the week

DetailViewController
	configureView - set up all the labels with passed dictionary information

WeatherData - 
	fetchWeatherData:zipCode
		- build out the URL using:
			- format = json
			- num_of_days = 5 // worldweatheronline.com will only do 5 
			- key = my api key to worldweatheronline.com
			- g = zipCode(passed in)
			- EX: http://api.worldweatheronline.com/free/v1/weather.ashx?format=json&num_of_days=5&key=hrzmceph6pvt2yfupey6y9ef&q=97035
		- go out to given URL and get JSON data
		- parse data into dictionary
		- return dictionary


