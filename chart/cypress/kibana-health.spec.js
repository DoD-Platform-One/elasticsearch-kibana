describe('Basic Kibana', function() {
  it('Check Kibana UI is accessible', function() {
    //cy.visit( 'https://elasticsearch-kibana-kb-http:5601/login?next=%2F') 
    cy.visit(Cypress.env('url')+"/login?next=%2F")
    cy.title().should('eq', 'Elastic')
    cy.get('[name="username"]')
    .type('elastic')
    .should('have.value', 'elastic');
    
    
  })
})
