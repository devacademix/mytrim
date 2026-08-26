import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { TopFreelancersRoutingModule } from './top-freelancers-routing.module';
import { TopFreelancersComponent } from './top-freelancers.component';
import { IvyCarouselModule } from 'angular-responsive-carousel';
import { MDBBootstrapModule } from 'angular-bootstrap-md';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';

@NgModule({
  declarations: [
    TopFreelancersComponent
  ],
  imports: [
    CommonModule,
    TopFreelancersRoutingModule,
    IvyCarouselModule,
    MDBBootstrapModule.forRoot(),
    NgxSkeletonLoaderModule
  ]
})
export class TopFreelancersModule { }
