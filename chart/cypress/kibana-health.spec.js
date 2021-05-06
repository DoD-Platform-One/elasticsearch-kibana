describe('Basic Kibana', function() {
  it('Check Kibana UI is accessible', function() {
    

    cy.visit( 'https://elasticsearch-kibana-kb-http:5601') 
    cy.title().should('eq', 'Elastic')
    
    
  })
})
