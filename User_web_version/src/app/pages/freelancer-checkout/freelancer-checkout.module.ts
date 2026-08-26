import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { FreelancerCheckoutRoutingModule } from './freelancer-checkout-routing.module';
import { FreelancerCheckoutComponent } from './freelancer-checkout.component';
import { MDBBootstrapModule } from 'angular-bootstrap-md';
import { FormsModule } from '@angular/forms';
import { NgxPayPalModule } from 'ngx-paypal';

@NgModule({
  declarations: [
    FreelancerCheckoutComponent
  ],
  imports: [
    CommonModule,
    FreelancerCheckoutRoutingModule,
    MDBBootstrapModule.forRoot(),
    FormsModule,
    NgxPayPalModule
  ]
})
export class FreelancerCheckoutModule { }
