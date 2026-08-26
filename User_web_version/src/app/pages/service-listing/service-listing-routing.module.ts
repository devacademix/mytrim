import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ServiceListingComponent } from './service-listing.component';

const routes: Routes = [
  {
    path: '',
    component: ServiceListingComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ServiceListingRoutingModule { }
