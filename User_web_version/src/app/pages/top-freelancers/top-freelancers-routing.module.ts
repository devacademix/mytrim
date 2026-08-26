import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TopFreelancersComponent } from './top-freelancers.component';

const routes: Routes = [
  {
    path: '',
    component: TopFreelancersComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class TopFreelancersRoutingModule { }
