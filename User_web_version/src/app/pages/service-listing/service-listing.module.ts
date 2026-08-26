import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ServiceListingRoutingModule } from './service-listing-routing.module';
import { ServiceListingComponent } from './service-listing.component';
import { MDBBootstrapModule } from 'angular-bootstrap-md';
import { IvyCarouselModule } from 'angular-responsive-carousel';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
@NgModule({
  declarations: [
    ServiceListingComponent
  ],
  imports: [
    CommonModule,
    ServiceListingRoutingModule,
    MDBBootstrapModule.forRoot(),
    IvyCarouselModule,
    NgxSkeletonLoaderModule
  ]
})
export class ServiceListingModule { }
