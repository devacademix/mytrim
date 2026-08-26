import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { FreelancerCheckoutComponent } from './freelancer-checkout.component';

const routes: Routes = [
  {
    path: '',
    component: FreelancerCheckoutComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class FreelancerCheckoutRoutingModule { }
