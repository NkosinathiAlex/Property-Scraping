import scrapy
from scrapy.selector import Selector


class Property24Spider(scrapy.Spider):
    name = "property24"
    allowed_domains = ["property24.com"]
    start_urls = ["https://www.property24.com/for-sale/kwazulu-natal/2", "https://www.property24.com/for-sale/gauteng/1", "https://www.property24.com/for-sale/western-cape/9"
                  ," https://www.property24.com/for-sale/free-state/3", "https://www.property24.com/for-sale/mpumalanga/5", "https://www.property24.com/for-sale/eastern-cape/7",
                  "https://www.property24.com/for-sale/north-west/6", " https://www.property24.com/for-sale/limpopo/14","https://www.property24.com/for-sale/northern-cape/8", ]


    ## Function that gets called once the responds comes back
    ## Filling this function with all the data we want from the pages

    def parse(self, response):
        houses = response.css('.js_listingResultsContainer')

        url = 'https://www.property24.com'
        for house in houses:
            relative_url = house.css('.js_rollover_container a::attr(href)').get()
            if relative_url:
                house_url = url + relative_url
                yield response.follow(house_url, callback=self.parse_house_page)
        next_page = response.css('.p24_pager .pull-right   ::attr(href)').get()
        if next_page is not None:
            next_page_url = next_page
            yield response.follow(next_page_url, callback=self.parse)

    def parse_house_page(self, response):
        houses = response.css('.p24_listing')
        for house in houses:
            yield {
                'Province': house.css('div.p24_breadCrumb a[title^="Property for sale in"]::text').get(),
                'City': house.css('div.p24_breadCrumb a[title^="Property and houses for sale in"]::text').get(),
                'place': house.css('.p24_location::text').get(),
                'Price': house.css('.p24_price::text').get(),
                'Bedrooms':  house.css('.p24_featureDetails[title="Bedrooms"] span::text').get(),
                'Bathrooms':  houses.css('.p24_featureDetails[title="Bathrooms"] span::text').get(),
                'Parking Spaces': houses.css('.p24_featureDetails[title="Parking Spaces"] span::text').get(),
                'Erf Size': house.css('.p24_featureDetails[title="Erf Size"] span::text').get(),
                'description': ' '.join(house.css('div.js_visibleText ::text').getall()),
                'Listing Number': house.css('div.p24_propertyOverviewRow div.p24_info::text').get(),
                'Type of Property': house.css('div.p24_propertyOverviewRow div.p24_propertyOverviewKey:contains("Type of Property") + div div.p24_info::text').get(),
                'Lifestyle': house.css('div.p24_propertyOverviewRow div.p24_propertyOverviewKey:contains("Lifestyle") + div div.p24_info::text').get(),
                'Listing Date': house.css('div.p24_propertyOverviewRow div.p24_propertyOverviewKey:contains("Listing Date") + div div.p24_info::text').get(),
                'Floor Size': house.css('div.p24_propertyOverviewRow div.p24_propertyOverviewKey:contains("Floor Size") + div div.p24_info::text').get(),
                'Levies': house.css('div.p24_propertyOverviewRow div.p24_propertyOverviewKey:contains("Levies") + div div.p24_info::text').get(),
                'Rates and Taxes': house.css('div.p24_propertyOverviewRow div.p24_propertyOverviewKey:contains("Rates and Taxes") + div div.p24_info::text').get(),
                'Pets Allowed Y/N': house.css('div.p24_propertyOverviewRow div.p24_propertyOverviewKey:contains("Pets Allowed") + div div.p24_info::text').get(),
                'Agent name': house.css('div.p24_agentInfo h5 a::text').get(),

            }













