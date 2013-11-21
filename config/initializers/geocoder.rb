Geocoder.configure(

	:timeout => 30


	
	)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => 40.7143528,
      'longitude'    => -74.0059731,
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  "94305 US",
  [
    {
      'latitude'     => 100.7143528,
      'longitude'    => -200.0059731,
      'address'      => 'Another place',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
	)

Geocoder::Lookup::Test.add_stub(
  "94303 FR",
  [
    {
      'latitude'     => 10,
      'longitude'    => -1,
      'address'      => 'Another place',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
	)